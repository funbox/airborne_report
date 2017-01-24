require 'spec_helper'
require 'report_airborne/rspec_html_formatter'

describe ReportAirborne::RspecHtmlFormatter do
  it do
    described_class.new(nil).start(nil)
  end

  it do
    described_class.new(nil).start(nil)
    report = double(to_hash: { 'tests' => {}, 'statuses' => {
                      'passed' => 0, 'failed' => 0, 'pending' => 0
                    } })
    allow(ReportAirborne::Report).to receive(:new).and_return(report)
    described_class.new(nil).stop(nil)
  end
end
