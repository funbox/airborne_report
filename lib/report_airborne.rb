require 'report_airborne/version'
require 'report_airborne/rspec_json_formatter'
require 'report_airborne/message'

module ReportAirborne
  # Your code goes here...
end

module Airborne
  module RestClientRequester
    alias origin_make_request make_request

    def make_request(*args)
      response = origin_make_request(*args)
      request = response.request
      ReportAirborne::Message.good_case(location, request, response)
      response
    rescue
      ReportAirborne::Message.bad_case(location, args, response, get_url(args[1]))
      response
    end

    private

    def location
      inspect.to_s.split('(').last.split(')').first
    end
  end
end
