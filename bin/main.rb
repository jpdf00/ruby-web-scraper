#! /usr/bin/env ruby
require 'nokogiri'
require 'open-uri'

link_1 = "http://gatherer.wizards.com/pages/search/default.aspx?page=0&output=compact&action=advanced&type=+![\"Token\"]"


puts 'Chose a Card Type:'
type = "Creature" #get.chomp
puts 'Inlcude or Exclude from the search (In/Ex):'
inclusion = ""
link_1 = link_1 + "+#{inclusion}[#{type}]"
puts 'Chose a Card Supertype:'
supertype = "Legendary"
puts 'Inlcude or Exclude from the search (In/Ex):'
inclusion = "!"
link_1 = link_1 + "+#{inclusion}[#{supertype}]"
link_1 = link_1 + "&subtype="
puts 'Chose a Card Subtype:'
subtype = "Dragon"
puts 'Inlcude or Exclude from the search (In/Ex):'
inclusion = ""
link_1 = link_1 + "+#{inclusion}[#{subtype}]"

name_array = []
link_array = []
set_array = []


link = "http://gatherer.wizards.com/pages/search/default.aspx?page=0&output=compact&action=advanced&type=+[#{type}]+![#{supertype}]+![\"Token\"]&subtype=+[#{subtype}]"
doc_1 = Nokogiri::HTML(URI.open(link_1))

doc_1.xpath('//td//a').each do |content|
  name_array << content.content unless content.content == ""
end

doc_1.xpath('//td//div//a//@href').each do |link|
  link_array << link.content unless link.content == ""
end

link_2 = "https://gatherer.wizards.com/Pages/Card/Details.aspx?multiverseid=#{link_array[1]}"
doc_2 = Nokogiri::HTML(URI.open(link_2))

doc_2.css("#ctl00_ctl00_ctl00_MainContent_SubContent_SubContent_currentSetSymbol a").each do |link|
  set_array << link.content
end

puts name_array
#otherSetsRow
#
#doc_2 = Nokogiri::HTML(URI.open(link_2))
#
#p page_array.uniq
loop do
  flag = true
  while flag == true do
    puts "Chose a Card #{mock_term}:"
    term = "Creature" #get.chomp
    puts 'Inlcude or Exclude from the search? (I/E):'
    inclusion = "" #get.chomp
    puts "Want to add another? (Y/N):"
    repeat = "N" #get.chomp
    flag = false if repeat == "N"
    link_1 = link_1 + "+#{inclusion}[#{term}]"
  end
  break if mock_term == "subtype"
  mock_term
end
