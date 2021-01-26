#! /usr/bin/env ruby
require 'nokogiri'
require 'open-uri'

class Validation
  attr_reader :current_term, :inclusion_validation, :repeat_validation, :type_array

  def initialize
    @term = ['Type or Supertype', 'Subtype']
    @current_term = ''
    @type_array = []
    type_list
    @inclusion_validation = %w[I E]
    @repeat_validation = %w[Y N]
  end

  def change_term
    @current_term = @term.shift
    @term.push(@current_term)
  end

  private

  def type_list
    @validation_page = Nokogiri::HTML(URI.parse('https://gatherer.wizards.com/Pages/Advanced.aspx').open)

    @validation_page.css('#autoCompleteSourceBoxtypeAddText3_InnerTextBoxcontainer a').each do |link|
      @type_array << link.content
    end
  end
end
