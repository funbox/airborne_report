module ReportAirborne
  class Report
    def self.blank
      {
        'tests' => {}
      }
    end

    def get_after_json(before_json, notification)
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
          after_json[location] = new_case(example).merge(before_json[location])
        else
          after_json[location] = new_case(example)
        end

        statuses['all'] += 1
        statuses[example.execution_result.status.to_s] += 1
      end

      {
        'statuses' => statuses,
        'tests' => after_json
      }
    end

    def new_case(example)
      {
        'full_description' => example.full_description,
        'status' => example.execution_result.status
      }
    end
  end
end
