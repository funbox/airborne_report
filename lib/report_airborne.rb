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
      save!(args, response)
      response
    rescue SocketError => error
      wasted_save(args, response)
      error
    end

    private

    def save!(args, response)
      if response.is_a?(RestClient::Response)
        full_save(response)
      else
        wasted_save(args, response)
      end
    end

    def full_save(response)
      request = response.request
      JsonFile.push(
        location,
        ReportAirborne::Message.full(request, response).to_hash
      )
    end

    def wasted_save(args, response)
      url = get_url(args[1])
      JsonFile.push(
        location,
        ReportAirborne::Message.wasted(args, response, url).to_hash
      )
    end

    def location
      inspect.to_s.split('(').last.split(')').first
    end
  end
end
