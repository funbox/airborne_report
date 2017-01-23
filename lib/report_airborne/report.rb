module ReportAirborne
  class Report
    def initialize(before_json, notification)
      after_json = {}

      statuses = {
        'all' => 0,
        'passed' => 0,
        'failed' => 0,
        'pending' => 0
      }

      notification.examples.map do |example|
        location = example.metadata[:location]
        if before_json[location]
          after_json[location] = Message.extra(example).to_hash.merge(before_json[location])
        else
          after_json[location] = Message.extra(example).to_hash
        end

        statuses['all'] += 1
        statuses[example.execution_result.status.to_s] += 1
      end

      @json = {
        'statuses' => statuses,
        'tests' => after_json
      }
    end

    def self.blank
      {
        'tests' => {}
      }
    end

    def to_hash
      @json
    end
  end
end
