require 'spec_helper'
require 'webmock/rspec'
require 'multi_json'

describe 'Integration testing' do
  context 'good request and response' do
    before do
      stub_request(:get, 'http://api.local/')
        .to_return(
          status: 200,
          body: MultiJson.dump({'test' => 'check'}),
          headers: {'Content-Type' => 'application/json'}
        )
    end

    it 'returns all info' do
      get 'http://api.local/'
      expect_status(200)
    end
  end

  context 'expect fail' do
    it 'returns fail' do
      get 'http://api.local/'
      expect_status(200)
    end
  end

  context 'test skip' do
    it 'returns pending' do
      skip
    end
  end
end
