# URBANopt Reporting Gem

### [back to main docs](../)

The URBANopt&trade; Reporting Gem defines the URABNopt reports (Scenario and Feature reports). It also includes the default reporting measure which query results from the energyplus sql database and reports it in the Feature reports.

[RDoc Documentation](https://urbanopt.github.io/urbanopt-reporting-gem/)

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'urbanopt-reporting'
```

And then execute:

    $ bundle install
    $ bundle update

Or install it yourself as:

    $ gem install 'urbanopt-reporting'

## Testing

Check out the repository and then execute:

    $ bundle install
    $ bundle update
    $ bundle exec rake

## Releasing

* Update change log
* Update version in `/lib/urbanopt/reporting/version.rb`
* Merge down to master
* run `rake release` from master
