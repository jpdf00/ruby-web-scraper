#! /usr/bin/env ruby
require 'nokogiri'
require 'open-uri'
require_relative '../lib/result'
require_relative '../lib/validation'
require_relative '../lib/link'

class Input
  def initialize(link, validation)
    @link = link
    @validation = validation
    @term = ''
    @inclusion = ''
    @do_again = ''
  end

  def input_entry
    loop do
      puts
      card_type_entry
      puts
      inclusion_entry
      puts
      do_again
      puts
      @link.build_link(@term, @inclusion, @validation.current_term)
      puts @link.chosen_terms
      break if @repeat == 'N'
    end
  end

  private

  def card_type_entry
    loop do
      print "Chose a Card #{@validation.current_term}: "
      @term = gets.chomp.downcase.capitalize
      break if @validation.type_array.include?(@term) || @validation.current_term == 'Subtype'

      puts "Not a valid Card #{@validation.current_term}. "
    end
  end

  def inclusion_entry
    loop do
      print 'Include or Exclude from the search? (I/E): '
      @inclusion = gets.chomp.upcase
      break if @validation.inclusion_validation.include? @inclusion

      puts 'Invalid Input. Chose either I or N'
    end
  end

  def do_again
    loop do
      print 'Want to add another? (Y/N): '
      @repeat = gets.chomp.upcase
      break if @validation.repeat_validation.include? @repeat

      puts 'Invalid Input. Chose either Y or N'
    end
  end
end

def show_result(result, validation)
  puts "Your search returned #{result.length} results."
  puts
rescue Errno::ETIMEDOUT
  puts 'Site is down. Try again in a couple minutes.'
else
  list_result = 'N'
  loop do
    print 'Want to view a list with the results? (Y/N): '
    list_result = gets.chomp.upcase
    break if validation.include? list_result

    puts 'Invalid Input. Chose either Y or N'
  end
  puts
  puts result if list_result == 'Y'
end

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

link = Link.new
validation = Validation.new
result = Result.new
input = Input.new(link, validation)
puts
puts "The possible Types or Supertypes are: #{validation.type_array}"
puts
validation.change_term
input.input_entry
validation.change_term
input.input_entry
puts
result.web_scrape(link.base_link, link.options_link, link.type_link, link.subtype_link)
show_result(result.name_array, validation.repeat_validation)
