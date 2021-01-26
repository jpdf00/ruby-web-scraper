#! /usr/bin/env ruby
require 'nokogiri'
require 'open-uri'
require_relative '../lib/scraper_logic'

puts
puts '------------ Welcome to the Magic: The Gathering Web Scraper ------------'
puts
puts '  This tool is design to search for Magic: The Gatering cards based'
puts ' on their types and subtypes, and returns a list of matches.'
puts
puts ' 1.1 - You will be prompted to enter a Card Type or Supertype.'
puts ' This is mandatory and accepts any valid card type or supertype.'
puts
puts ' 1.2 - You will be prompted to chose if you want to Include or Exclude the previous entry.'
puts ' To Include enter "I". That will return only results that have that card Type or Supertype.'
puts ' To Exclude enter "E". That will return only results that do not have that card Type or Supertype.'
puts
puts ' 1.3 - You will be prompted to chose if you want to enter another Type or Supertype'
puts ' To do so enter "Y". That will repeat this process'
puts ' To move to the next step enter "N". That will move to the next step'
puts
puts ' 2.1 - You will be prompted to enter a Card Subtype.'
puts ' This is not mandatory and accepts any value.'
puts ' Keep in mind that entering a value that do not match a valid Card Subtype an chosing to Include'
puts ' will result in an empty search.'
puts
puts ' 2.2 - You will be prompted to chose if you want to Include or Exclude the previous entry.'
puts ' To Include enter "I". That will return only results that have that card Subtype.'
puts ' To Exclude enter "E". That will return only results that do not have that card Subtype.'
puts
puts ' 2.3 - You will be prompted to chose if you want to enter another Subtype'
puts ' To do so enter "Y". That will repeat this process'
puts ' To move to the next step enter "N". That will move to the next step'
puts
puts '-------------------------------------------------------------------------'

search = Search.new
validation = Validation.new

2.times do
  term = ''
  inclusion = ''
  repeat = ''
  validation.change_term
  loop do
    puts
    loop do
      print "Chose a Card #{validation.current_term}: "
      term = gets.chomp.downcase.capitalize
      break if validation.current_term == 'Subtype'

      break if validation.type_list.include? term

      puts "Not a valid Card #{validation.current_term}. "
      puts "The valid Card #{validation.current_term}s are #{validation.type_list}"
    end
    loop do
      print 'Include or Exclude from the search? (I/E): '
      inclusion = gets.chomp.upcase
      break if validation.inclusion_validation.include? inclusion

      puts 'Invalid Input. Chose either I or N'
    end
    loop do
      print 'Want to add another? (Y/N): '
      repeat = gets.chomp.upcase
      break if validation.repeat_validation.include? repeat

      puts 'Invalid Input. Chose either Y or N'
    end
    puts
    puts search.build_link(term, inclusion, validation.current_term)
    break if repeat == 'N'
  end
end

puts
begin
  puts "Your search returned #{search.web_scrape.length} results."
  puts
rescue Errno::ETIMEDOUT
  puts 'Site is down. Try again in a couple minutes.'
else
  show_results = 'N'
  loop do
    print 'Want to view a list with the results? (Y/N): '
    show_results = gets.chomp.upcase
    break if validation.repeat_validation.include? show_results

    puts 'Invalid Input. Chose either Y or N'
  end
  puts
  puts search.name_array if show_results == 'Y'
end
