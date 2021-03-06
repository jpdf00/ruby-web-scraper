#! /usr/bin/env ruby
require_relative '../lib/validation'
require_relative '../lib/link'
require_relative '../lib/result'

validation = Validation.new
link = Link.new
result = Result.new
INVALID = 'ausydgfku'.freeze
TYPE_1 = 'Creature'.freeze
TYPE_2 = 'Legendary'.freeze
SUBTYPE = 'Dragon'.freeze
TERM_1 = 'Type'.freeze
TERM_2 = 'Subtype'.freeze
INCLUSION = 'I'.freeze
EXCLUSION = 'E'.freeze
short_link = 'The current search returns all cards that '

describe Validation do
  describe '#type_list' do
    types = ['Artifact', 'Basic', 'Conspiracy', 'Creature', 'Eaturecray',
             'Enchantment', 'Ever', 'Host', 'Instant', 'Land', 'Legendary', 'Ongoing',
             'Phenomenon', 'Plane', 'Planeswalker', 'Scariest', 'Scheme', 'See', 'Snow',
             'Sorcery', 'Summon', 'Tribal', 'Vanguard', 'World', "You'll", 'Artifact',
             'Basic', 'Conspiracy', 'Creature', 'Eaturecray', 'Enchantment', 'Ever',
             'Host', 'Instant', 'Land', 'Legendary', 'Ongoing', 'Phenomenon', 'Plane',
             'Planeswalker', 'Scariest', 'Scheme', 'See', 'Snow', 'Sorcery', 'Summon',
             'Tribal', 'Vanguard', 'World', "You'll"]
    count = 0
    types.length.times do
      current_type = types[count]
      it "Returns true on #{current_type}" do
        expect(validation.type_array.include?(current_type)).to eql(true)
      end
      count += 1
    end
    it 'Returns false on empty string' do
      expect(validation.type_array.include?('')).to eql(false)
    end
    it 'Returns false on invalid input' do
      expect(validation.type_array.include?(INVALID)).to eql(false)
    end
  end

  describe '#change_term' do
    it 'Returns empty string if the method is not called' do
      expect(validation.current_term.empty?).to eql(true)
    end
    it 'Returns "Type or Supertype" on first call' do
      validation.change_term
      expect(validation.current_term).to eql('Type or Supertype')
    end
    it 'Returns "Subtype" on second call' do
      validation.change_term
      expect(validation.current_term).to eql('Subtype')
    end
  end

  describe '#inclusion_validation' do
    inclusion_options = %w[E I]
    count = 0
    inclusion_options.length.times do
      current_option = inclusion_options[count]
      it "Returns true on #{current_option}" do
        expect(validation.inclusion_validation.include?(current_option)).to eql(true)
      end
      count += 1
    end
    it 'Returns false on empty string' do
      expect(validation.inclusion_validation.include?('')).to eql(false)
    end
    it 'Returns false on invalid input' do
      expect(validation.inclusion_validation.include?(INVALID)).to eql(false)
    end
  end

  describe '#repeat_validation' do
    repeat_options = %w[Y N]
    count = 0
    repeat_options.length.times do
      current_option = repeat_options[count]
      it "Returns true on #{current_option}" do
        expect(validation.repeat_validation.include?(current_option)).to eql(true)
      end
      count += 1
    end
    it 'Returns false on empty string' do
      expect(validation.repeat_validation.include?('')).to eql(false)
    end
    it 'Returns false on invalid input' do
      expect(validation.repeat_validation.include?(INVALID)).to eql(false)
    end
  end
end

describe Link do
  describe '#build_link' do
    it 'Returns the correct search terms for Types inclusive' do
      short_link += "have the #{TERM_1} \"#{TYPE_1}\", "
      expect(link.build_link(TYPE_1, INCLUSION, TERM_1)).to eql(short_link)
    end
    it 'Returns the correct search terms for Types exclusive' do
      short_link += "do not have the #{TERM_1} \"#{TYPE_2}\", "
      expect(link.build_link(TYPE_2, EXCLUSION, TERM_1)).to eql(short_link)
    end
    it 'Returns the correct search terms for Subtypes' do
      short_link += "have the #{TERM_2} \"#{SUBTYPE}\", "
      expect(link.build_link(SUBTYPE, INCLUSION, TERM_2)).to eql(short_link)
    end
  end
end

describe Result do
  describe '#web_scrape' do
    it 'Returns the correct search results' do
      result.web_scrape(link.base_link, link.options_link, link.type_link, link.subtype_link)
      expect(result.name_array.length).to eql(151)
    end
    it 'Does not returns the incorrect search results' do
      result.web_scrape(link.base_link, link.options_link, link.type_link, link.subtype_link)
      expect(result.name_array.length).not_to eql(200)
    end
  end
end
