require 'spec_helper'

describe ReportAirborne::Message do
  it do
    described_class.extra(double(full_description: nil, execution_result: double(status: 'qwe')))
  end
end
