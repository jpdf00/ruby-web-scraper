#! /usr/bin/env ruby
require 'nokogiri'
require 'open-uri'

class Link
  attr_reader :base_link, :options_link, :type_link, :subtype_link, :chosen_terms

  def initialize
    @base_link = 'http://gatherer.wizards.com/pages/search/default.aspx?'
    @options_link = '&output=compact&action=advanced'
    @type_link = '&type=+!["Token"]'
    @subtype_link = '&subtype='
    @chosen_terms = 'The current search returns all cards that '
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
  end
end
