require 'spec_helper'
require 'report_airborne/rspec_html_formatter'

describe ReportAirborne::RspecHtmlFormatter do
  subject { described_class.new(nil) }

  describe '#start' do
    it 'not raise exception' do
      expect { subject.start(nil) }.not_to raise_exception
    end
  end

  describe '#stop' do
    let(:report) do
      double(
        to_hash: {
          'tests' => {},
          'statuses' => {
            'passed' => 0,
            'failed' => 0,
            'pending' => 0
          }
        }
      )
    end

    before { allow(ReportAirborne::Report).to receive(:new).and_return(report) }

    it 'not raise exception' do
      expect { subject.stop(nil) }.not_to raise_exception
    end
  end
end
