require 'rspec/core/formatters/base_formatter'
require 'multi_json'
require 'report_airborne/json_file'
require 'report_airborne/report'

module ReportAirborne
  class RspecJsonFormatter < RSpec::Core::Formatters::BaseFormatter
    RSpec::Core::Formatters.register self, :start, :stop

    def start(_notification)
      JSONFile.save(Report.blank)
    end

    def stop(notification)
      tests = JSONFile.tests
      JSONFile.destroy

      report = Report.new.get_after_json(tests, notification)
      craft_json(report)
    end

    def craft_json(report)
      File.open('report.json', 'w') do |file|
        file.write(MultiJson.dump(report))
      end
    end
  end
end
