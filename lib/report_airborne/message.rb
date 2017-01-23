require 'multi_json'
require 'report_airborne/json_file'

module ReportAirborne
  class Message
    def initialize(message)
      @message = message
    end

    def self.full(request, response)
      new({
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
      })
    end

    def self.wasted(args, response, url)
      new({
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
      })
    end

    def save(location)
      JSONFile.push(location, @message)
    end
  end
end
