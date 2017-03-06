require 'spec_helper'
require 'airborne_report/report'

describe AirborneReport::Report do
  describe '.new' do
    let(:example1) { double(metadata: { location: '1' }, execution_result: double(status: 'passed'), exception: nil) }
    let(:example2) { double(metadata: { location: '2' }, execution_result: double(status: 'passed'), exception: nil) }
    let(:examples) { [example1, example2] }
    let(:before_json) { { '2' => [{}] } }
    let(:notification) { double(examples: examples) }

    before { allow(AirborneReport::Message).to receive(:extra).and_return(double(to_hash: {})) }

    it 'not raise exception' do
      expect { expect(described_class.new(before_json, notification)) }.not_to raise_exception
    end

    it 'set date' do
      expect(described_class.new(before_json, notification).to_hash)
        .to eq(
          'statuses' => {
            'all' => 2,
            'passed' => 2,
            'failed' => 0,
            'pending' => 0
          },
          'tests' => {
            '1' => {},
            '2' => {'responses' => [{}]}
          }

        )
    end
  end

  describe '.blank' do
    it 'get date' do
      expect(described_class.blank)
        .to eq(
          'tests' => {}
        )
    end
  end

  describe '#to_hash' do
    let(:example1) { double(metadata: { location: '1' }, execution_result: double(status: 'passed'), exception: nil) }
    let(:example2) { double(metadata: { location: '2' }, execution_result: double(status: 'passed'), exception: nil) }
    let(:examples) { [example1, example2] }
    let(:before_json) { { '2' => [{}] } }
    let(:notification) { double(examples: examples) }

    before { allow(AirborneReport::Message).to receive(:extra).and_return(double(to_hash: {})) }

    it 'not raise exception' do
      expect { expect(described_class.new(before_json, notification).to_hash) }.not_to raise_exception
    end

    it 'set date' do
      expect(described_class.new(before_json, notification).to_hash)
        .to eq(
          'statuses' => {
            'all' => 2,
            'passed' => 2,
            'failed' => 0,
            'pending' => 0
          },
          'tests' => {
            '1' => {},
            '2' => {'responses' => [{}]}
          }

        )
    end
  end
end
