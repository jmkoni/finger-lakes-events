# Finger Lakes Events

Simple application built to share events throughout the Finger Lakes!

## System Requirements

**NOTE: if you want to use a version manager, please skip to the next section. Using a version manager is highly recommended.**

This application uses [Ruby 3.4.4](https://www.ruby-lang.org/en/documentation/installation/). You'll need the following
- [RubyGems](https://rubygems.org/pages/download) (installed with rvm/rbenv)
- bundler (`gem install bundler`)
- required libraries (run `bundle install` from the application home directory)

### If you want to use a version manager

You can use either [rbenv](https://github.com/rbenv/rbenv) or [rvm](https://rvm.io). Further instructions assume use of rvm.
1. Install rvm.
2. `rvm install ruby-3.4.4`
3. `cd` into `finger-lakes-events` directory
4. This should create a `finger-lakes` gemset (a self-contained set of installed gems to avoid conflicts).
5. `gem install bundler`
6. `bundle install`
7. You are good to go!

## Running Locally

`rails db:setup`
`rails c`
Then create a user with whatever email you feel like (doesn't matter if it's valid, it's just local...) by running this in the rails console:
`User.create(name: #{your name}, email: #{your email})`
Then...
`rails s`
And you should be good to go!

## Running tests

`rails test` and `rails test:system` for system tests
That's it!

## Running the linter

`bundle exec standardrb --fix`
