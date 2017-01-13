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
      puts "request.headers: #{response.request.headers}"
      puts "response: #{response}"
      puts "response.headers: #{response.headers}"
      response
    end
  end
end
