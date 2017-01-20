require 'report_airborne/version'
require 'multi_json'
require 'report_airborne/rspec_json_formatter'

module ReportAirborne
  # Your code goes here...
end

module Airborne
  module RestClientRequester
    alias origin_make_request make_request

    def make_request(*args)
      response = origin_make_request(*args)
      request = response.request
      good_case(request, response)
      response
    rescue
      bad_case(args, response)
      response
    end

    private

    def good_case(request, response)
      before_json = get_before_json
      after_json = {
        'tests' => get_after_tests(before_json['tests'], request, response)
      }

      File.open('report.json', 'w') do |file|
        file.write(MultiJson.dump(after_json))
      end
    end

    def bad_case(args, response)
      before_json = get_before_json
      after_json = {
        'tests' => before_json['tests'].merge(location => wasted_test(args, response))
      }
      File.open('report.json', 'w') do |file|
        file.write(MultiJson.dump(after_json))
      end
    end

    def get_before_json
      MultiJson.load(File.read('report.json'))
    end

    def get_after_tests(before_tests, request, response)
      before_tests.merge(location => new_test(request, response))
    end

    def location
      inspect.to_s.split('(').last.split(')').first
    end

    def new_test(request, response)
      {
        'time' => Time.now,
        'request' => {
          'method' => request.method,
          'url' => request.url,
          'headers' => request.headers,
          'body' => request.args
        },
        'response' => {
          'headers' => response.headers,
          'body' => MultiJson.load(response)
        }
      }
    end

    def wasted_test(args, response)
      {
        'time' => Time.now,
        'request' => {
          'method' => args[0],
          'url' => get_url(args[1]),
          'headers' => args[2][:headers],
          'body' => args[2][:body]
        },
        'response' => {
          'body' => response
        }
      }
    end
  end
end
