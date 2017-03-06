module AirborneReport
  module Storage
    module Tests
      class << self
        def find_or_create(location)
          @tests ||= {}
          unless @tests[location]
            @tests[location] = []
          end
          @tests[location]
        end

        def all
          @tests ||= {}
          @tests
        end
      end
    end
  end
end
