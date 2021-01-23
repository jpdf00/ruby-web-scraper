#! /usr/bin/env ruby

require 'nokogiri'
require 'open-uri'

# Fetch and parse HTML document
type = "Creature"
subtype = "Dragon"
supertype = "Legendary"
TOKEN = "Token"
name_array = []
link_array = []
set_array = []


link_1 = "http://gatherer.wizards.com/pages/search/default.aspx?page=0&output=compact&action=advanced&type=+[#{type}]+![#{supertype}]+![#{TOKEN}]&subtype=+[#{subtype}]"
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
puts link_array
#otherSetsRow
#
#doc_2 = Nokogiri::HTML(URI.open(link_2))
#
#p page_array.uniq
