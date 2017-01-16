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

      after_json = after_json(get_before_json, request, response)
      File.open("report.json", 'w') do |file|
        file.write(MultiJson.dump(after_json))
      end
      response
    end

    private

    def get_before_json
      MultiJson.load(File.read('report.json'))
    end

    def after_json(before_json, request, response)
      before_case = before_case(before_json)
      after_case = after_case(before_case, request, response)

      before_json.pop
      before_json.push(after_case)
    end

    def before_case(before_json)
      before_json.last
    end

    def after_case(before_case, request, response)
      before_case.merge(new_case(request, response))
    end

    def new_case(request, response)
      {
        request: {
          method: request.method,
          url: request.url,
          headers: request.headers
        },
        response: {
          headers: response.headers,
          body: MultiJson.load(response)
        }
      }
    end
  end
end
