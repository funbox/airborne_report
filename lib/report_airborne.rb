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
      ress =  File.read('report.json')
      res = {
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
      res = MultiJson.dump(MultiJson.load(ress).push(res))
      File.open("report.json", 'w') { |file| file.write(res) }
      response
    end
  end
end
