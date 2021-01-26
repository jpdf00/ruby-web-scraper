#! /usr/bin/env ruby
require 'nokogiri'
require 'open-uri'
require_relative '../lib/scraper_logic'

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
  puts search.name_array if show_results == 'Y'
end
