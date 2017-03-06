require 'rspec/core/formatters/base_formatter'
require 'haml'
require 'airborne_report/report'
require 'airborne_report/storage/tests'

module AirborneReport
  class RspecHtmlFormatter < RSpec::Core::Formatters::BaseFormatter
    RSpec::Core::Formatters.register self, :stop

    def stop(notification)
      tests = AirborneReport::Storage::Tests.all

      report = Report.new(tests, notification).to_hash
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
