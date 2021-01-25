#! /usr/bin/env ruby
require 'nokogiri'
require 'open-uri'

class Validation
  attr_reader :current_term, :inclusion_validation, :repeat_validation

  def initialize
    @term = %w[Type Subtype]
    @current_term = ''
    @type_array = []
    @subtype_array = []
    @validation_page = Nokogiri::HTML(URI.open('https://gatherer.wizards.com/Pages/Advanced.aspx'))
    @inclusion_validation = %w[I E]
    @repeat_validation = %w[Y N]
  end

  def type_list
    @validation_page.css('#autoCompleteSourceBoxtypeAddText3_InnerTextBoxcontainer a').each do |link|
      @type_array << link.content
    end
    @type_array
  end

  def chage_term
    @current_term = @term.shift
    @term.push(@current_term)
  end
end

class Search
  attr_reader :link, :name_array, :validation

  def initialize
    @page = 0
    @base_link = 'http://gatherer.wizards.com/pages/search/default.aspx?'
    @options_link = '&output=compact&action=advanced'
    @type_link = '&type=+!["Token"]'
    @subtype_link = '&subtype='
    @name_array = []
    @link_array = []
    @page_array = []
  end

  def build_link(term, inclusion, current_term)
    inclusion = inclusion == 'E' ? '!' : ''
    @type_link += "+#{inclusion}[\"#{term}\"]" if current_term == 'Type'
    @subtype_link += "+#{inclusion}[\"#{term}\"]" if current_term == 'Subtype'
  end

  def web_scrape
    loop do
      full_link = "#{@base_link}page=#{@page}#{@options_link}#{@type_link}#{@subtype_link}"
      retrieved_page = Nokogiri::HTML(URI.open(full_link))

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
