# AirborneReport

Generate reports on tests with the [airborne](https://rubygems.org/gems/airborne) gem.

## Installation

Add this line to your application's Gemfile:

```ruby
group :test do
  gem 'airborne_report'
end
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install airborne_report
    
## Usage

```ruby
# spec/spec_helper.rb
require 'airborne_report'
```

```
bundle exec rspec --format AirborneReport::RspecJsonFormatter
```

or 

```
bundle exec rspec --format AirborneReport::RspecHtmlFormatter
```

After that you can find the report in `report.json` or `report.html`.

## Development

After checking out the repo, run `bin/setup` to install dependencies. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/funbox/airborne_report. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

