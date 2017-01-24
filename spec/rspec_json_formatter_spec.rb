require 'spec_helper'

describe ReportAirborne::RspecJsonFormatter do
  it do
    described_class.new(nil).start(nil)
  end

  it do
    report = double(to_hash: {})
    allow(ReportAirborne::Report).to receive(:new).and_return(report)
    described_class.new(nil).stop(nil)
  end
end
