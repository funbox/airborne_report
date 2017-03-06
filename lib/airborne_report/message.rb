require 'multi_json'
require 'airborne_report/json_file'

module AirborneReport
  class Message
    def initialize(message)
      @message = message
    end

    def self.full(request, response)
      new(
        'time' => Time.now,
        'response' => {
          'headers' => response.headers,
          'body' => load_response(response),
          'request' => {
            'method' => request.method,
            'url' => request.url,
            'headers' => request.headers,
            'body' => request.args
          }
        }
      )
    end

    def self.load_response(response)
      MultiJson.load(response)
    rescue MultiJson::ParseError
      response
    end

    def self.wasted(args, response, url)
      new(
        'time' => Time.now,
        'response' => {
          'body' => response,
          'request' => {
            'method' => args[0],
            'url' => url,
            'headers' => args[2][:headers],
            'body' => args[2][:body]
          }
        }
      )
    end

    def self.extra(example)
      new(
        'full_description' => example.full_description,
        'status' => example.execution_result.status.to_s
      )
    end

    def to_hash
      @message
    end
  end
end
