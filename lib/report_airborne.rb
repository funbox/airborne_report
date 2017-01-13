require "report_airborne/version"

module ReportAirborne
  # Your code goes here...
end

module Airborne
  module RestClientRequester
    alias_method :origin_make_request, :make_request

    def make_request(*args)
      response = origin_make_request(*args)
      puts "request: #{response.request.inspect}"
      puts "response: #{response}"
      response
    end
  end
end
