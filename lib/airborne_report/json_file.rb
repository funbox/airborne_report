require 'multi_json'

module AirborneReport
  class JsonFile
    NAME = 'storage.json'.freeze

    def self.save(json)
      File.open(NAME, 'w') do |file|
        file.write(MultiJson.dump(json))
      end
    end

    def self.push(key, value)
      save('tests' => tests.merge(key => value))
    rescue Errno::ENOENT
    end

    def self.tests
      MultiJson.load(File.read(NAME))['tests']
    end

    def self.destroy
      File.delete(NAME)
    end
  end
end
