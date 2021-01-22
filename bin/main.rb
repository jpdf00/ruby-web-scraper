#! /usr/bin/env ruby

require 'nokogiri'
require 'open-uri'

# Fetch and parse HTML document
type = "Creature"
subtype = "Dragon"
supertype = "Legendary"
TOKEN = "Token"
list = {}
name_array = []
link_array = []


link_1 = "http://gatherer.wizards.com/pages/search/default.aspx?page=0&output=compact&action=advanced&type=+[#{type}]+![#{supertype}]+![#{TOKEN}]&subtype=+[#{subtype}]"
link_2 = "http://gatherer.wizards.com/pages/search/default.aspx?page=0&output=checklist&action=advanced&type=+[#{type}]+![#{supertype}]+![#{TOKEN}]&subtype=+[#{subtype}]"

doc_1 = Nokogiri::HTML(URI.open(link_1))
doc_2 = Nokogiri::HTML(URI.open(link_2))

# Search for nodes by xpath
doc_1.xpath('//td//a').each do |content|
  name_array << content.content unless content.content == ""
end

doc_1.xpath('//td//div//a//@href').each do |link|
  i = 0
  list[name_array[i]] << link unless link.content == ""
  i += 1
end
puts list


#
#doc_2 = Nokogiri::HTML(URI.open(link_2))
#
#p page_array.uniq
