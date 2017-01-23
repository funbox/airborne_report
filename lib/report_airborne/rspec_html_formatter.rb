require 'rspec/core/formatters/base_formatter'
require 'haml'
require 'report_airborne/json_file'
require 'report_airborne/report'

module ReportAirborne
  class RspecHtmlFormatter < RSpec::Core::Formatters::BaseFormatter
    RSpec::Core::Formatters.register self, :start, :stop

    def start(_notification)
      JsonFile.save(Report.blank)
    end

    def stop(notification)
      tests = JsonFile.tests
      JsonFile.destroy

      report = Report.new.get_after_json(tests, notification)
      craft_html(report)
    end

    def craft_html(report)
      contents = File.read(File.expand_path('../view/report.html.haml', __FILE__))
      html = "<style>\n#{File.read(File.expand_path('../view/style.css', __FILE__))}\n</style>\n"
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
