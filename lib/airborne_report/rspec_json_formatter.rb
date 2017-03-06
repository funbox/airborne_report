require 'rspec/core/formatters/base_formatter'
require 'multi_json'
require 'airborne_report/report'
require 'airborne_report/storage/tests'

module AirborneReport
  class RspecJsonFormatter < RSpec::Core::Formatters::BaseFormatter
    RSpec::Core::Formatters.register self, :stop

    def stop(notification)
      tests = AirborneReport::Storage::Tests.all

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
