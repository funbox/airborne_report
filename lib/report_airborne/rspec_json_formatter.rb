require 'rspec/core/formatters/base_formatter'
require 'haml'
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
      craft_html(report)
    end

    def craft_json(report)
      File.open('report.json', 'w') do |file|
        file.write(MultiJson.dump(report))
      end
    end

    def craft_html(report)
      contents = File.read(File.expand_path('../report.html.haml', __FILE__))
      html = "<style>\n#{File.read(File.expand_path('../style.css', __FILE__))}\n</style>\n"
      i = 0
      html += Haml::Engine.new(contents).render(
        Object.new,
        :@tests => report['tests'],
        :@statuses => report['statuses'],
        :@i => i
      )
      File.open('report.html', 'w') do |file|
        file.write(html)
      end
    end
  end
end
