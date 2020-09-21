# URBANopt Reporting Gem

The URBANopt<sup>&trade;</sup> Reporting Gem defines the URABNopt reports (Scenario and Feature reports). It also includes the default reporting measure which query results from the energyplus sql database and reports it in the Feature reports.


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

* Update CHANGELOG.md
* Run `rake rubocop:auto_correct`
* Update version in `/lib/version.rb`
* Create PR to master, after tests and reviews complete, then merge
* Locally - from the master branch, run `rake release`
* On GitHub, go to the releases page and update the latest release tag. Name it “Version x.y.z” and copy the CHANGELOG entry into the description box.
