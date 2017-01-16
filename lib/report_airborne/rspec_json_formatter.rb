require 'rspec/core/formatters/base_formatter'

module ReportAirborne
  class RspecJsonFormatter < RSpec::Core::Formatters::BaseFormatter
    RSpec::Core::Formatters.register self, :start, :example_started

    def start(notification)
      File.open("report.json", 'w') { |file| file.write('[]') }
    end

    def example_started(notification)
      after_string = MultiJson.dump(after_json(notification))
      File.open("report.json", 'w') do |file|
        file.write(after_string)
      end
      notification
    end

    private

    def after_json(notification)
      before_json.push(new_case(notification))
    end

    def before_json
      MultiJson.load(File.read('report.json'))
    end

    def new_case(notification)
      {
        full_description: notification.example.full_description
      }
    end
  end
end
