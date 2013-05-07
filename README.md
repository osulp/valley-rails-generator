Valley Rails Generator
======================

The Valley Rails Generator is a project heavily based on [suspenders](https://github.com/thoughtbot/suspenders) by thoughtbot
and used to generate our base rails applications at OSU Libraries & Press.

It includes our common testing solutions and what we consider "best practice" defaults.

Installation
------------

Install the gem

```
gem install valley-rails-generator
```

To run the generator use:

```
valleyrailsgen projectname
```

This will create a Rails 3.2 app in `projectname`. This script creates a new git repository. It is not meant to be used against an existing repo.

Dependencies
------------

The following are system dependencies are required for this generator to work:

1. Ruby 1.9.2 or greater
2. PhantomJS (for capybara's poltergeist driver)

Gems
------------

This generator installs a variety of gems, primarily for testing purposes.

1. [RSpec](https://github.com/rspec/rspec) for unit testing
2. [Shoulda-Matchers](https://github.com/thoughtbot/shoulda-matchers) for commonly used single-line rspec tests.
3. [Factory Girl](https://github.com/thoughtbot/factory_girl) for factory generation.
4. [Capybara](https://github.com/jnicklas/capybara) for integration testing.
5. [Poltergeist](https://github.com/jonleighton/poltergeist) for headless javascript testing.
6. [simplecov](https://github.com/colszowka/simplecov) for test coverage reports.
7. [Guard](https://github.com/guard/guard.git) and [guard-rspec](https://github.com/guard/guard-rspec) for automated running of tests.
8. [Spring](https://github.com/jonleighton/spring) for Rails preloading (integrated with guard-rspec).
9. [Better_Errors](https://github.com/charliesome/better_errors.git) for improved error pages in development.
10. [Jazz Hands](https://github.com/nixme/jazz_hands) for a combination of pry tools to improve the Rails console in development.
11. [Active Model Serializers](https://github.com/rails-api/active_model_serializers.git) for defining the JSON output of a model.
12. [Yard](https://github.com/lsegal/yard) for tag-based in-code documentation.
13. [Simple Form](https://github.com/plataformatec/simple_form.git) for easier form generation.
