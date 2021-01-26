#! /usr/bin/env ruby
require 'nokogiri'
require 'open-uri'

class Result
  def show_result(result, validation)
    puts "Your search returned #{result.length} results."
    puts
  rescue Errno::ETIMEDOUT
    puts 'Site is down. Try again in a couple minutes.'
  else
    list_result = 'N'
    loop do
      print 'Want to view a list with the results? (Y/N): '
      list_result = gets.chomp.upcase
      break if validation.include? list_result

      puts 'Invalid Input. Chose either Y or N'
    end
    puts
    puts result if list_result == 'Y'
  end
end
