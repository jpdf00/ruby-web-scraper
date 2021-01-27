#! /usr/bin/env ruby
require 'nokogiri'
require 'open-uri'

class Result
  attr_reader :name_array

  def initialize
    @page = 0
    @name_array = []
    @page_array = []
  end

  def web_scrape(base_link, options_link, type_link, subtype_link)
    loop do
      full_link = "#{base_link}page=#{@page}#{options_link}#{type_link}#{subtype_link}"
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
