require 'spec_helper'
require 'report_airborne/report'

describe ReportAirborne::Report do
  it do
    allow(ReportAirborne::Message).to receive(:extra).and_return(double(to_hash: {}))
    example1 = double(metadata: { location: '1' }, execution_result: double(status: 'passed'))
    example2 = double(metadata: { location: '2' }, execution_result: double(status: 'passed'))
    described_class.new({ '2' => {} }, double(examples: [example1, example2])).to_hash
  end
end
