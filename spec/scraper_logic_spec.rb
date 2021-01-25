require_relative '..\lib\scraper_logic'

validation = Validation.new
search = Search.new
INVALID = 'ausydgfku'
TYPE_1 = 'Creature'
TYPE_2 = 'Legendary'
SUBTYPE = 'Dragon'
TERM_1 = 'Type'
TERM_2 = 'Subtype'
INCLUSION = 'I'
EXCLUSION = 'E'

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
        expect(validation.type_list.include?(current_type)).to eql(true)
      end
      count += 1
    end
    it 'Returns false on empty string' do
      expect(validation.type_list.include?('')).to eql(false)
    end
    it 'Returns false on invalid input' do
      expect(validation.type_list.include?(INVALID)).to eql(false)
    end
  end

  describe '#change_term' do
    it 'Returns empty string if the method is not called' do
      expect(validation.current_term.empty?).to eql(true)
    end
    it 'Returns Type on first call' do
      validation.change_term
      expect(validation.current_term).to eql('Type')
    end
    it 'Returns Subtype on second call' do
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

describe Search do
  describe '#build_link' do
    it "Returns the correct search terms for Types" do
      expect(search.build_link(TYPE_1, INCLUSION, TERM_1)).to eql("The current search returns all cards that have the #{TERM_1} \"#{TYPE_1}\", ")
    end
    it "Does not returns the incorrect search terms" do
      expect(search.build_link(TYPE_2, EXCLUSION, TERM_1)).not_to eql("The current search returns all cards that have the #{TERM_1} \"#{TYPE_1}\", have the #{TERM_1} \"#{TYPE_2}\", ")
    end
    it "Returns the correct search terms for Subtypes" do
      expect(search.build_link(SUBTYPE, INCLUSION, TERM_2)).to eql("The current search returns all cards that have the #{TERM_1} \"#{TYPE_1}\", does not have the #{TERM_1} \"#{TYPE_2}\", have the #{TERM_2} \"#{SUBTYPE}\", ")
    end
  end

  describe '#web_scrape' do
    it "Returns the correct search results" do
      expect(search.web_scrape.length).to eql(151)
    end
    it "Does not returns the incorrect search results" do
      expect(search.web_scrape.length).not_to eql(200)
    end
  end
end