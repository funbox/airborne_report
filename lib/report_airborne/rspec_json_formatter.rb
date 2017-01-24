require 'rspec/core/formatters/base_formatter'
require 'multi_json'
require 'report_airborne/json_file'
require 'report_airborne/report'

module ReportAirborne
  class RspecJsonFormatter < RSpec::Core::Formatters::BaseFormatter
    RSpec::Core::Formatters.register self, :start, :stop

    def start(_notification)
      ReportAirborne::JsonFile.save(Report.blank)
    end

    def stop(notification)
      tests = ReportAirborne::JsonFile.tests
      ReportAirborne::JsonFile.destroy

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
