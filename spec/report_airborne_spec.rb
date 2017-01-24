require 'spec_helper'

describe Airborne::RestClientRequester do
  it do
    allow_any_instance_of(described_class).to receive(:origin_make_request).and_return({})
    allow(ReportAirborne::JsonFile).to receive(:push)
    expect(
      make_request(
        :get,
        'http://api.local',
        headers: { 'login' => 'WAT' }
      )
    ).to eq({})
  end

  it do
    allow_any_instance_of(described_class).to receive(:origin_make_request).and_raise(SocketError)
    allow(ReportAirborne::JsonFile).to receive(:push)
    expect do
      make_request(
        :get,
        'http://api.local',
        headers: { 'login' => 'WAT' }
      )
    end.to raise_error(SocketError)
  end

  let(:stub_response) { double(is_a?: true, request: double(method: nil, url: nil, headers: nil, args: nil), headers: nil) }

  it do
    allow_any_instance_of(described_class).to receive(:origin_make_request).and_return(
      stub_response
    )
    allow(ReportAirborne::JsonFile).to receive(:push)
    allow(MultiJson).to receive(:load).and_return({})
    expect(
      make_request(
        :get,
        'http://api.local',
        headers: { 'login' => 'WAT' }
      )
    ).to eq(stub_response)
  end
end
