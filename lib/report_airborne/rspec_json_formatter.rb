require 'rspec/core/formatters/base_formatter'

module ReportAirborne
  class RspecJsonFormatter < RSpec::Core::Formatters::BaseFormatter
    RSpec::Core::Formatters.register self, :start, :stop

    def start(notification)
      File.open("report.json", 'w') { |file| file.write('[]') }
    end

    def stop(notification)
      after_json = get_after_json(get_before_json, notification)

      File.open("report.json", 'w') do |file|
        file.write(MultiJson.dump(after_json))
      end
    end

    private

    def get_before_json
      MultiJson.load(File.read('report.json'))
    end

    def get_after_json(before_json, notification)
      after_json = []

      before_json.size.times do |i|
        after_json.push(new_case(notification.examples[i]).merge(before_json[i]))
      end

      after_json
    end

    def new_case(example)
      {
        full_description: example.full_description,
        status: example.execution_result.status
      }
    end
  end
end
