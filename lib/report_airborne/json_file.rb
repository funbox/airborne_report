class JSONFile
  def push(key, value)
    save(
      {
        'tests' => tests.merge(key => value)
      }
    )
  end

  private

  def tests
    MultiJson.load(File.read('report.json'))['tests']
  end

  def save(json)
    File.open('report.json', 'w') do |file|
      file.write(MultiJson.dump(json))
    end
  end
end
