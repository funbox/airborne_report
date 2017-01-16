require "report_airborne/version"

module ReportAirborne
  # Your code goes here...
end

module Airborne
  module RestClientRequester
    alias_method :origin_make_request, :make_request

    def make_request(*args)
      response = origin_make_request(*args)
      request = response.request
      res = {
        request: {
          method: request.method,
          url: request.url,
          headers: request.headers
        },
        response: {
          headers: response.headers,
          body: response.to_s
        }
      }
      puts "res: #{res}"
      response
    end
  end
end
