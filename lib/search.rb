#! /usr/bin/env ruby
require 'nokogiri'
require 'open-uri'

class Search
  attr_reader :name_array

  def initialize
    @page = 0
    @base_link = 'http://gatherer.wizards.com/pages/search/default.aspx?'
    @options_link = '&output=compact&action=advanced'
    @type_link = '&type=+!["Token"]'
    @subtype_link = '&subtype='
    @chosen_terms = 'The current search returns all cards that '
    @name_array = []
    @link_array = []
    @page_array = []
  end

  def build_link(term, inclusion, current_term)
    symbol = inclusion == 'E' ? '!' : ''
    have = inclusion == 'E' ? 'do not have' : 'have'
    if current_term == 'Subtype'
      @subtype_link += "+#{symbol}[\"#{term}\"]"
    else
      @type_link += "+#{symbol}[\"#{term}\"]"
    end
    @chosen_terms += "#{have} the #{current_term} \"#{term}\", "
    @chosen_terms
  end

  def web_scrape
    loop do
      full_link = "#{@base_link}page=#{@page}#{@options_link}#{@type_link}#{@subtype_link}"
      retrieved_page = Nokogiri::HTML(URI.parse(full_link).open)
      retrieved_page.xpath('//td//a').each do |content|
        @name_array << content.content unless content.content == ''
      end

      retrieved_page.css('#ctl00_ctl00_ctl00_MainContent_SubContent_topPagingControlsContainer a').each do |link|
        @page_array << link.content.to_i - 1 unless link.content.to_i.zero?
      end

      break if @page == @page_array[-1] or @page_array.empty?

      @page += 1
    end
    @name_array
  end
end
