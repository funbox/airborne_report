require 'multi_json'

module ReportAirborne
  class Message
    def self.good_case(location, request, response)
      before_json = get_before_json
      after_json = {
        'tests' => get_after_tests(location, before_json['tests'], request, response)
      }

      File.open('report.json', 'w') do |file|
        file.write(MultiJson.dump(after_json))
      end
    end

    def self.bad_case(location, args, response, url)
      before_json = get_before_json
      after_json = {
        'tests' => before_json['tests'].merge(location => wasted_test(args, response, url))
      }
      File.open('report.json', 'w') do |file|
        file.write(MultiJson.dump(after_json))
      end
    end

    def self.get_before_json
      MultiJson.load(File.read('report.json'))
    end

    def self.get_after_tests(location, before_tests, request, response)
      before_tests.merge(location => new_test(request, response))
    end

    def self.new_test(request, response)
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

    def self.wasted_test(args, response, url)
      {
        'time' => Time.now,
        'request' => {
          'method' => args[0],
          'url' => url,
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
