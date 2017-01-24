require 'multi_json'

class ReportAirborne::JsonFile
  def self.push(key, value)
    save(
      {
        'tests' => tests.merge(key => value)
      }
    )
  end

  def self.save(json)
    File.open('storage.json', 'w') do |file|
      file.write(MultiJson.dump(json))
    end
  end

  def self.tests
    MultiJson.load(File.read('storage.json'))['tests']
  end

  def self.destroy
    File.delete('storage.json')
  end
end
