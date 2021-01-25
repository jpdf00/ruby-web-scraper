#! /usr/bin/env ruby
require 'nokogiri'
require 'open-uri'

module Validation
  @@term = ['Type', 'Supertype', 'Subtype']
  @@current_term = ''
  @@type_array =[]
  @@subtype_array =[]
  @@validation_page = Nokogiri::HTML(URI.open('https://gatherer.wizards.com/Pages/Advanced.aspx'))
  @@inclusion_validation = ['I', 'E']
  @@repeat_validation = ['Y', 'N']

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

  def self.current_term
    @@current_term
  end

  def self.inclusion_validation
    @@inclusion_validation
  end

  def self.repeat_validation
    @@repeat_validation
  end

  def self.chage_term
    @@current_term = @@term.shift
    @@term.push(@@current_term)
  end

  def self.term_validation?(term)
    check = if @@current_term == 'Subtype'
              Validation.subtype_list.include? term
            else
              Validation.type_list.include? term
            end
    check
  end
end

class Search
  attr_reader :link, :name_array

  def initialize
    @page = 0
    @base_link = 'http://gatherer.wizards.com/pages/search/default.aspx?'
    @search_link = '&output=compact&action=advanced&type=+!["Token"]'
    @name_array = []
    @link_array = []
    @page_array = []
  end

  def build_link(term, inclusion)
    @search_link += "&subtype=" if Validation.current_term == "Subtype"
    @search_link += "+#{inclusion}[\"#{term}\"]"
  end

  def web_scrape
    loop do
      retrieved_page = Nokogiri::HTML(URI.open("#{@base_link}page=#{@page.to_s}#{@search_link}"))

      retrieved_page.xpath('//td//a').each do |content|
        @name_array << content.content unless content.content == ""
      end

      retrieved_page.xpath('//td//div//a//@href').each do |link|
        @link_array << link.content unless link.content == ""
      end

      retrieved_page.css('#ctl00_ctl00_ctl00_MainContent_SubContent_topPagingControlsContainer a').each do |link|
        @page_array << link.content.to_i - 1 unless link.content.to_i == 0
      end

      break if @page == @page_array[-1] or @page_array.empty?
      @page += 1
    end
    @name_array
  end
end
