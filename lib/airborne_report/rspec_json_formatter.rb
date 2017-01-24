require 'rspec/core/formatters/base_formatter'
require 'multi_json'
require 'airborne_report/json_file'
require 'airborne_report/report'

module AirborneReport
  class RspecJsonFormatter < RSpec::Core::Formatters::BaseFormatter
    RSpec::Core::Formatters.register self, :start, :stop

    def start(_notification)
      AirborneReport::JsonFile.save(Report.blank)
    end

    def stop(notification)
      tests = AirborneReport::JsonFile.tests
      AirborneReport::JsonFile.destroy

      report = Report.new(tests, notification).to_hash
      craft_json(report)
    end

    def craft_json(report)
      File.open('report.json', 'w') do |file|
        file.write(MultiJson.dump(report))
      end
    end
  end
end
