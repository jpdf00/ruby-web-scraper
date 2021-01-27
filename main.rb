#! /usr/bin/env ruby

# wrapper to make this program work on repl.it

require_relative './bin/main'

require 'bundler/inline'

gemfile true do
  source 'http://rubygems.org'
  gem 'nokogiri'
end
