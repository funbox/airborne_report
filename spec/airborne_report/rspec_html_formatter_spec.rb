require 'spec_helper'
require 'airborne_report/rspec_html_formatter'

describe AirborneReport::RspecHtmlFormatter do
  subject { described_class.new(nil) }

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

    before { allow(AirborneReport::Report).to receive(:new).and_return(report) }

    it 'not raise exception' do
      expect { subject.stop(nil) }.not_to raise_exception
    end
  end
end
