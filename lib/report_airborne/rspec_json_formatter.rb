require 'rspec/core/formatters/base_formatter'
require 'haml'

module ReportAirborne
  class RspecJsonFormatter < RSpec::Core::Formatters::BaseFormatter
    RSpec::Core::Formatters.register self, :start, :stop

    def start(_notification)
      build_file(blank)
    end

    def stop(notification)
      after_json = get_after_json(get_before_json['tests'], notification)
      destroy_file
      craft_json(after_json)
      craft_html(after_json)
    end

    def craft_json(after_json)
      File.open('report.json', 'w') do |file|
        file.write(MultiJson.dump(after_json))
      end
    end

    def craft_html(after_json)
      info = after_json
      contents = File.read(File.expand_path('../report.html.haml', __FILE__))
      html = "<style>\n#{File.read(File.expand_path('../style.css', __FILE__))}\n</style>\n"
      i = 0
      html += Haml::Engine.new(contents).render(
        Object.new,
        :@tests => info['tests'],
        :@statuses => info['statuses'],
        :@i => i
      )
      File.open('report.html', 'w') do |file|
        file.write(html)
      end
    end

    def get_before_json
      MultiJson.load(File.read('report.json'))
    end

    def get_after_json(before_json, notification)
      after_json = {}

      statuses = {
        'all' => 0,
        'passed' => 0,
        'failed' => 0,
        'pending' => 0
      }

      notification.examples.map do |example|
        location = example.metadata[:location]
        if before_json[location]
          after_json[location] = new_case(example).merge(before_json[location])
        else
          after_json[location] = new_case(example)
        end

        statuses['all'] += 1
        statuses[example.execution_result.status.to_s] += 1
      end

      {
        'statuses' => statuses,
        'tests' => after_json
      }
    end

    def new_case(example)
      {
        'full_description' => example.full_description,
        'status' => example.execution_result.status
      }
    end

    def blank
      {
        'statuses' => {},
        'tests' => {}
      }
    end

    def build_file(blank)
      File.open('report.json', 'w') do |file|
        file.write(MultiJson.dump(blank))
      end
    end

    def destroy_file
      File.delete('report.json')
    end
  end
end
