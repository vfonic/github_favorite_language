# Github Favorite Language

[![Gem Version](https://badge.fury.io/rb/github_favorite_language.svg)](http://badge.fury.io/rb/github_favorite_language)
[![Build Status](https://travis-ci.org/vfonic/github_favorite_language.svg)](https://travis-ci.org/vfonic/github_favorite_language)
[![Dependency Status](https://gemnasium.com/vfonic/github_favorite_language.svg)](https://gemnasium.com/vfonic/github_favorite_language)
[![Coverage Status](https://coveralls.io/repos/vfonic/github_favorite_language/badge.svg)](https://coveralls.io/r/vfonic/github_favorite_language)
[![Code Climate](https://codeclimate.com/github/vfonic/github_favorite_language/badges/gpa.svg)](https://codeclimate.com/github/vfonic/github_favorite_language)

Find out any GitHub user's favorite programming language!

## Installation

Add this line to your application's Gemfile:

```ruby
  gem 'github_favorite_language'
```

And then execute:

```bash
  $ bundle
```

Or install it yourself as:

```bash
  $ gem install github_favorite_language
```

## Usage

The gem comes with the command line tool, but can be also called inside the ruby code.


Example:

Bash:

```bash
    $ github_favorite_language vfonic
```

Ruby:

```ruby
  require 'github_favorite_language'

  puts GithubFavoriteLanguage.new(username: 'vfonic').favorite_language
```

Or:

```ruby
  require 'github_favorite_language'

  GithubFavoriteLanguage.new(username: 'vfonic').print_favorite_language
```

This will fetch vfonic repos and return the name of the main language of most repositories.
For GitHub documentation refer to: [https://developer.github.com/v3/](https://developer.github.com/v3/)


## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake rspec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To fix an issue, update the version number in `version.rb`, and then create a pull request.

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

