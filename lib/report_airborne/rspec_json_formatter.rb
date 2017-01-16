require 'rspec/core/formatters/base_formatter'

module ReportAirborne
  class RspecJsonFormatter < RSpec::Core::Formatters::BaseFormatter
    RSpec::Core::Formatters.register self, :start

    def start(notification)
      File.open("report.json", 'w') { |file| file.write('[]') }
    end
  end
end
