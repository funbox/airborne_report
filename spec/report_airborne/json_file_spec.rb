require 'spec_helper'

describe ReportAirborne::JsonFile do
  it do
    described_class.save({
      'tests' => {}
    })
    described_class.push('qwe', 'asd')
  end

  it do
    described_class.save({
      'tests' => {}
    })
    described_class.destroy
  end
end
