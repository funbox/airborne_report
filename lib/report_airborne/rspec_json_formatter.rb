require 'rspec/core/formatters/base_formatter'
require 'haml'

module ReportAirborne
  class RspecJsonFormatter < RSpec::Core::Formatters::BaseFormatter
    RSpec::Core::Formatters.register self, :start, :stop

    def start(notification)
      File.open("report.json", 'w') { |file| file.write(MultiJson.dump(
        {
          "statuses" => {},
          "tests" => {}
        }
      )) }
    end

    def stop(notification)
      after_json = MultiJson.dump(get_after_json(get_before_json["tests"], notification))

      File.open("report.json", 'w') do |file|
        file.write(after_json)
      end

      craft_html
    end

    def craft_html
      info = MultiJson.load(File.read('report.json'))
      contents = File.read(File.expand_path('../report.html.haml', __FILE__))
      html = "<style>\n#{File.read(File.expand_path('../style.css', __FILE__))}\n</style>\n"
      i = 0
      html = html + Haml::Engine.new(contents).render(Object.new, {
        :@tests => info["tests"],
        :@statuses => info["statuses"],
        :@i => i
      })
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

      statuses = {
        "passed" => 0,
        "failed" => 0,
        "pending" => 0
      }

      notification.examples.map do |example|
        location = example.metadata[:location]
        if before_json[location]
          after_json[location] = new_case(example).merge(before_json[location])
        else
          after_json[location] = new_case(example)
        end

        statuses[example.execution_result.status.to_s] += 1
      end

      {
        "statuses" => statuses,
        "tests" => after_json
      }
    end

    def new_case(example)
      {
        "full_description" => example.full_description,
        "status" => example.execution_result.status
      }
    end
  end
end
