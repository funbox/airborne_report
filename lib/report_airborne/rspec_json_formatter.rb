require 'rspec/core/formatters/base_formatter'
require 'haml'

module ReportAirborne
  class RspecJsonFormatter < RSpec::Core::Formatters::BaseFormatter
    RSpec::Core::Formatters.register self, :start, :stop

    def stop(notification)
      after_json = MultiJson.dump(get_after_json(get_before_json, notification))

      File.open("report.json", 'w') do |file|
        file.write(after_json)
      end

      craft_json
    end

    def craft_json
      after_json = MultiJson.load(File.read('report.json'))
      contents = File.read(File.expand_path('../report.html.haml', __FILE__))
      html = "<style>\n#{File.read(File.expand_path('../style.css', __FILE__))}\n</style>"
      i = 0
      html = html + Haml::Engine.new(contents).render(Object.new, {:@after_json => after_json, :@i => i})
      File.open("report.html", 'w') do |file|
        file.write(html)
      end
    end

    private

    def get_before_json
      MultiJson.load(File.read('report.json'))
    end

    def get_after_json(before_json, notification)
      after_json = {}

      notification.examples.map do |example|
        location = example.metadata[:location]
        if before_json[location]
          after_json[location] = new_case(example).merge(before_json[location])
        else
          after_json[location] = new_case(example)
        end
      end

      after_json
    end

    def new_case(example)
      {
        "full_description" => example.full_description,
        "status" => example.execution_result.status
      }
    end
  end
end
