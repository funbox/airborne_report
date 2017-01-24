require 'spec_helper'
require 'report_airborne/rspec_json_formatter'

describe ReportAirborne::RspecJsonFormatter do
  subject { described_class.new(nil) }

  describe '#start' do
    it 'not raise exception' do
      expect { subject.start(nil) }.not_to raise_exception
    end
  end

  describe '#stop' do
    let(:report) { double(to_hash: {}) }

    before { allow(ReportAirborne::Report).to receive(:new).and_return(report) }

    it 'not raise exception' do
      expect { subject.stop(nil) }.not_to raise_exception
    end
  end
end
