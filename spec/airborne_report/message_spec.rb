require 'spec_helper'

describe AirborneReport::Message do
  describe '.new' do
    it 'not raise exception' do
      expect { described_class.new({}) }.not_to raise_exception
    end
  end

  describe '.full' do
    let(:request) { double(method: nil, url: nil, headers: nil, args: nil) }
    let(:response) { double(headers: nil) }

    before do
      allow(MultiJson).to receive(:load).and_return({})
      allow(Time).to receive(:now).and_return('coffee time')
    end

    it 'not raise exception' do
      expect { described_class.full(request, response) }.not_to raise_exception
    end

    it 'set date' do
      expect(described_class.full(request, response).to_hash).to eq(
        'time' => 'coffee time',
        'request' => {
          'method' => nil,
          'url' => nil,
          'headers' => nil,
          'body' => nil
        },
        'response' => {
          'headers' => nil,
          'body' => {}
        }
      )
    end
  end

  describe '.load_response' do
    it 'returns response' do
      expect(described_class.load_response('{}')).to eq({})
    end

    context 'invalid' do
      it 'returns response' do
        expect(described_class.load_response('lol')).to eq('lol')
      end
    end
  end

  describe '.wasted' do
    let(:args) { [nil, nil, {headers: nil, body: nil}] }
    let(:response) { nil }
    let(:url) { nil }

    before { allow(Time).to receive(:now).and_return('coffee time') }

    it 'not raise exception' do
      expect { described_class.wasted(args, response, url) }.not_to raise_exception
    end

    it 'set date' do
      expect(described_class.wasted(args, response, url).to_hash).to eq(
        'time' => 'coffee time',
        'request' => {
          'method' => nil,
          'url' => nil,
          'headers' => nil,
          'body' => nil
        },
        'response' => {
          'body' => nil
        }
      )
    end
  end

  describe '.extra' do
    let(:example) { double(full_description: nil, execution_result: double(status: nil)) }

    it 'not raise exception' do
      expect { described_class.extra(example) }.not_to raise_exception
    end

    it 'set date' do
      expect(described_class.extra(example).to_hash).to eq(
        'full_description' => nil,
        'status' => ''
      )
    end
  end

  describe '#to_hash' do
    it 'not raise exception' do
      expect { described_class.new({}) }.not_to raise_exception
    end
  end
end
