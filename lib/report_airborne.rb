require "report_airborne/version"
require 'multi_json'
require 'report_airborne/rspec_json_formatter'

module ReportAirborne
  # Your code goes here...
end

module Airborne
  module RestClientRequester
    alias_method :origin_make_request, :make_request

    def make_request(*args)
      response = origin_make_request(*args)
      request = response.request

      after_json = get_after_json(get_before_json, request, response)

      File.open("report.json", 'w') do |file|
        file.write(MultiJson.dump(after_json))
      end
      response
    rescue
      after_json = get_before_json.merge(location => {})
      File.open("report.json", 'w') do |file|
        file.write(MultiJson.dump(after_json))
      end
      response
    end

    private

    def get_before_json
      MultiJson.load(File.read('report.json'))
    end

    def get_after_json(before_json, request, response)
      before_json.merge(location => new_case(request, response))
    end

    def location
      self.inspect.to_s.split("(").last.split(")").first
    end

    def new_case(request, response)
      {
        time: Time.now,
        request: {
          method: request.method,
          url: request.url,
          headers: request.headers,
          body: request.args
        },
        response: {
          headers: response.headers,
          body: MultiJson.load(response)
        }
      }
    end
  end
end
