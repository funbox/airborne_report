module AirborneReport
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

        hash = {}
        e = example.exception
        if e
          hash['exception'] =  {
            'class' => e.class.name,
            'message' => e.message,
            'backtrace' => e.backtrace,
          }
        end

        after_json[location] = craft_example(before_json, location, example).merge(hash)
        statuses = increment_statuses(statuses, example)
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

    private

    def craft_example(before_json, location, example)
      if before_json[location]
        Message.extra(example).to_hash.merge('responses' => before_json[location])
      else
        Message.extra(example).to_hash
      end
    end

    def increment_statuses(old_statuses, example)
      new_statuses = old_statuses
      new_statuses['all'] += 1
      new_statuses[example.execution_result.status.to_s] += 1
      new_statuses
    end
  end
end
