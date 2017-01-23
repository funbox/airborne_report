require 'multi_json'

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
      reincarnation_json(
        {
          'tests' => before_json['tests'].merge(location => @message)
        }
      )
    end

    def before_json
      MultiJson.load(File.read('report.json'))
    end

    def reincarnation_json(after_json)
      File.open('report.json', 'w') do |file|
        file.write(MultiJson.dump(after_json))
      end
    end
  end
end
