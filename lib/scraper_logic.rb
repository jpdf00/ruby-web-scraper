#! /usr/bin/env ruby
require 'nokogiri'
require 'open-uri'

module Validation

  @@type_array =[]
  @@subtype_array =[]
  @@validation_page = Nokogiri::HTML(URI.open('https://gatherer.wizards.com/Pages/Advanced.aspx'))

  def self.type_list
    @@validation_page.css("#autoCompleteSourceBoxtypeAddText3_InnerTextBoxcontainer a").each do |link|
      @@type_array << link.content
    end
    @@type_array
  end

  def self.subtype_list
    @@validation_page.css("#autoCompleteSourceBoxsubtypeAddText4_InnerTextBoxcontainer a").each do |link|
      @@subtype_array << link.content
    end
    @@subtype_array
  end
end

class Search
  attr_reader :current_term, :link, :inclusion_validation, :repeat_validation, :name_array

  def initialize
    @term = ['Type', 'Supertype', 'Subtype']
    @page = 0
    @base_link = 'http://gatherer.wizards.com/pages/search/default.aspx?'
    @search_link = '&output=compact&action=advanced&type=+!["Token"]'
    @type_validation = Validation.type_list
    @subtype_validation = Validation.subtype_list
    @inclusion_validation = ['I', 'E']
    @repeat_validation = ['Y', 'N']
    @name_array = []
    @link_array = []
    @page_array = []
  end

  def chage_term
    @current_term = @term.shift
    @term.push(@current_term)
  end

  def build_link(term, inclusion)
    @search_link += "&subtype=" if @current_term == "Subtype"
    @search_link += "+#{inclusion}[\"#{term}\"]"
  end

  def term_validation?(term)
    check = if @current_term == 'Subtype'
              @subtype_validation.include? term
            else
              @type_validation.include? term
            end
    check
  end

  def web_scrape
    loop do
      @doc_1 = Nokogiri::HTML(URI.open("#{@base_link}page=#{@page.to_s}#{@search_link}"))

      @doc_1.xpath('//td//a').each do |content|
        @name_array << content.content unless content.content == ""
      end

      @doc_1.xpath('//td//div//a//@href').each do |link|
        @link_array << link.content unless link.content == ""
      end

      @doc_1.css('#ctl00_ctl00_ctl00_MainContent_SubContent_topPagingControlsContainer a').each do |link|
        @page_array << link.content.to_i - 1 unless link.content.to_i == 0
      end

      break if @page == @page_array[-1] or @page_array.empty?
      @page += 1
    end
    @name_array
  end
end
