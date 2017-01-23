require 'report_airborne/version'
require 'report_airborne/rspec_json_formatter'
require 'report_airborne/message'
require 'report_airborne/json_file'

module ReportAirborne
  # Your code goes here...
end

module Airborne
  module RestClientRequester
    alias origin_make_request make_request

    def make_request(*args)
      storage = JSONFile.new
      response = origin_make_request(*args)
      save!(args, response, storage)
      response
    rescue SocketError => error
      wasted_save(args, response, storage)
      error
    end

    private

    def save!(args, response, storage)
      if response.is_a?(RestClient::Response)
        full_save(response, storage)
      else
        wasted_save(args, response, storage)
      end
    end

    def full_save(response, storage)
      request = response.request
      ReportAirborne::Message.full(request, response).save(location, storage)
    end

    def wasted_save(args, response, storage)
      url = get_url(args[1])
      ReportAirborne::Message.wasted(args, response, url).save(location, storage)
    end

    def location
      inspect.to_s.split('(').last.split(')').first
    end
  end
end
