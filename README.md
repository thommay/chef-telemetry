# Chef::Telemetry


## Installation

Add this line to your application's Gemfile:

```ruby
gem 'chef-telemetry'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install chef-telemetry

## Usage

require 'telemetry'
payload = { "event" => "command-line", "properties" => { "action" => "test", "platform" => "windows-10-x64", "version" => "1.16" } }
tel = Telemetry.new { |p| p.product = "chefdk"; p.origin = "command-line" }
tel.send payload

## Development

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/thommay/chef-telemetry.
