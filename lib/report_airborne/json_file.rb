class JSONFile
  def push(key, value)
    reincarnation_json(
      {
        'tests' => before_json.merge(key => value)
      }
    )
  end

  def before_json
    MultiJson.load(File.read('report.json'))['tests']
  end

  def reincarnation_json(after_json)
    File.open('report.json', 'w') do |file|
      file.write(MultiJson.dump(after_json))
    end
  end
end
