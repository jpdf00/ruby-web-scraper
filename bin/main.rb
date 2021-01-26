#! /usr/bin/env ruby
require 'nokogiri'
require 'open-uri'
require_relative '../lib/result'
require_relative '../lib/validation'
require_relative '../lib/search'
require_relative '../lib/input'

puts
puts '------------ Welcome to the Magic: The Gathering Web Scraper ------------'
puts
puts '  This tool is design to search for Magic: The Gatering cards based'
puts ' on their types and subtypes, and returns a list of matches.'
puts
puts ' 1 - You will be prompted to enter a Card Type or Supertype.'
puts ' This is mandatory and accepts any valid card type or supertype.'
puts
puts ' 2 - You will be prompted to chose if you want to Include or Exclude the previous entry.'
puts ' To Include enter "I". To Exclude enter "E".'
puts
puts ' 3 - You will be prompted to chose if you want to enter another Type or Supertype'
puts ' To do so enter "Y". To move to the next step enter "N".'
puts
puts ' 4 - You will redo the above processe now for Subtypes.'
puts ' This is not mandatory and accepts any value.'
puts
puts '-------------------------------------------------------------------------'

search = Search.new
validation = Validation.new
result = Result.new
input = Input.new(search, validation)
puts
puts "The possible Types or Supertypes are: #{validation.type_array}"
puts
validation.change_term
input.input_entry
validation.change_term
input.input_entry
puts
search.web_scrape
result.show_result(search.name_array, validation.repeat_validation)
