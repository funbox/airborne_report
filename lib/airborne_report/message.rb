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
        'request' => {
          'method' => request.method,
          'url' => request.url,
          'headers' => request.headers,
          'body' => request.args
        },
        'response' => {
          'headers' => response.headers,
          'body' => MultiJson.load(response)
        }
      )
    end

    def self.wasted(args, response, url)
      new(
        'time' => Time.now,
        'request' => {
          'method' => args[0],
          'url' => url,
          'headers' => args[2][:headers],
          'body' => args[2][:body]
        },
        'response' => {
          'body' => response
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