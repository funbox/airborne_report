require 'multi_json'

class JsonFile
  def self.push(key, value)
    save(
      {
        'tests' => tests.merge(key => value)
      }
    )
  end

  def self.save(json)
    File.open('report.json', 'w') do |file|
      file.write(MultiJson.dump(json))
    end
  end

  def self.tests
    MultiJson.load(File.read('report.json'))['tests']
  end

  def self.destroy
    File.delete('report.json')
  end
end
