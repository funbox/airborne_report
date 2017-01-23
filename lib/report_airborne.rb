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
      if response.is_a?(RestClient::Response)
        request = response.request
        ReportAirborne::Message.full(request, response).save(location)
      else
        url = get_url(args[1])
        ReportAirborne::Message.wasted(args, response, url).save(location)
      end
      response
    rescue SocketError => error
      url = get_url(args[1])
      ReportAirborne::Message.wasted(args, response, url).save(location)
      error
    end

    private

    def location
      inspect.to_s.split('(').last.split(')').first
    end
  end
end
