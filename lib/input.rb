#! /usr/bin/env ruby
require 'nokogiri'
require 'open-uri'

class Input
  def initialize(search, validation)
    @search = search
    @validation = validation
    @term = ''
    @inclusion = ''
    @do_again = ''
  end

  def input_entry
    loop do
      puts
      card_type_entry
      puts
      inclusion_entry
      puts
      do_again
      puts
      puts @search.build_link(@term, @inclusion, @validation.current_term)
      break if @repeat == 'N'
    end
  end

  private

  def card_type_entry
    loop do
      print "Chose a Card #{@validation.current_term}: "
      @term = gets.chomp.downcase.capitalize
      break if @validation.type_array.include?(@term) || @validation.current_term == 'Subtype'

      puts "Not a valid Card #{@validation.current_term}. "
    end
  end

  def inclusion_entry
    loop do
      print 'Include or Exclude from the search? (I/E): '
      @inclusion = gets.chomp.upcase
      break if @validation.inclusion_validation.include? @inclusion

      puts 'Invalid Input. Chose either I or N'
    end
  end

  def do_again
    loop do
      print 'Want to add another? (Y/N): '
      @repeat = gets.chomp.upcase
      break if @validation.repeat_validation.include? @repeat

      puts 'Invalid Input. Chose either Y or N'
    end
  end
end
