require 'spec_helper'

describe Airborne::RestClientRequester do
  subject do
    make_request(
      :get,
      'http://api.local',
      headers: {'login' => 'WAT'}
    )
  end

  before do
    allow_any_instance_of(described_class).to receive(:origin_make_request).and_return({})
    allow(AirborneReport::Storage::Tests).to receive(:find_or_create).and_return([])
  end

  it 'returns response' do
    expect(subject).to eq({})
  end

  context 'raise error' do
    before { allow_any_instance_of(described_class).to receive(:origin_make_request).and_raise(SocketError) }

    it 'returns raise error' do
      expect { subject }.to raise_error(SocketError)
    end
  end

  context 'is RestClient::Response' do
    let(:stub_response) do
      double(is_a?: true, request: double(method: nil, url: nil, headers: nil, args: {payload: nil}), headers: nil)
    end

    before do
      allow_any_instance_of(described_class).to receive(:origin_make_request).and_return(
        stub_response
      )
      allow(MultiJson).to receive(:load).and_return({})
    end

    it 'returns response' do
      expect(subject).to eq(stub_response)
    end
  end
end
