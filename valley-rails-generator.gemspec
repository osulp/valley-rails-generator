# -*- encoding: utf-8 -*-
$:.push File.expand_path('../lib', __FILE__)
require 'valley-rails-generator/version'
require 'date'

Gem::Specification.new do |s|
  s.required_ruby_version = '>= 1.9.2'
  s.add_dependency 'bundler', '~> 1.3'
  s.add_dependency 'rails', '3.2.13'
  s.authors = ['osulp']
  s.date = Date.today.strftime('%Y-%m-%d')

  s.description = <<-HERE
Valley Rails Generator is a rails generator developed by OSU Libraries & Press
to speed up the creation of new Rails projects. It contains our commonly-used
defaults.
  HERE

  s.email = 'lib.dev@oregonstate.edu'
  s.executables = `git ls-files -- bin/*`.split("\n").map { |file| File.basename(file) }
  s.extra_rdoc_files = %w[README.md LICENSE]
  s.files = `git ls-files`.split("\n")
  s.homepage = 'http://github.com/osulp/valley-rails-generator'
  s.name = 'valley-rails-generator'
  s.rdoc_options = ['--charset=UTF-8']
  s.require_paths = ['lib']
  s.summary = "Generates a rails app with OSU Valley Library's defaults."
  s.test_files = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.version = ValleyRailsGenerator::VERSION
end