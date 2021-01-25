#! /usr/bin/env ruby
require 'nokogiri'
require 'open-uri'
require_relative '..\lib\scraper_logic'

search = Search.new

loop do
  flag = true
  term = ''
  inclusion = ''
  repeat = ''
  Validation.chage_term
  while flag == true do
    puts
    loop do
      print "Chose a Card #{Validation.current_term}: "
      term = gets.chomp.downcase.capitalize
      break if Validation.term_validation?(term)
      puts
      puts "Not a valid Card #{Validation.current_term}. "
      puts Validation.type_list if Validation.current_term == 'Type'
      puts Validation.type_list if Validation.current_term == 'Supertype'
      print Validation.subtype_list if Validation.current_term == 'Subtype'
      puts
    end
    loop do
      print 'Include or Exclude from the search? (I/E): '
      inclusion = gets.chomp.upcase
      if search.inclusion_validation.include? inclusion
        inclusion = inclusion == 'E' ? '!':''
        break
      else
        puts
        puts 'Invalid Input'
        puts
      end
    end
    loop do
      print "Want to add another? (Y/N): "
      repeat = gets.chomp.upcase
      if search.repeat_validation.include? repeat
        break
      else
        puts
        puts 'Invalid Input'
        puts
      end
    end
    flag = false if repeat == 'N'
    search.build_link(term, inclusion)
  end
  break if Validation.current_term == "Subtype"
end

puts
puts "Your search returned #{search.web_scrape.length} results."
puts
puts search.name_array

#set_array = []
#
#link_2 = "https://gatherer.wizards.com/Pages/Card/Details.aspx?multiverseid=#{link_array[1]}"
#doc_2 = Nokogiri::HTML(URI.open(link_2))
#
#doc_2.css("#ctl00_ctl00_ctl00_MainContent_SubContent_SubContent_currentSetSymbol a").each do |link|
#  set_array << link.content
#end
