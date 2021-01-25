#! /usr/bin/env ruby
require 'nokogiri'
require 'open-uri'

class Search
  attr_reader :current_term, :link, :inclusion_validation, :repeat_validation

  def initialize
    @term = ['Type', 'Supertype', 'Subtype']
    @link = "http://gatherer.wizards.com/pages/search/default.aspx?page=0&output=compact&action=advanced&type=+![\"Token\"]"
    @type_validation = ['Artifact', 'Creature', 'Enchantment', 'Instant', 'Land', 'Planeswalker', 'Sorcery', 'Tribal']
    @supertype_validation = ['Basic', 'Legendary', 'Snow', 'World']
    @subtype_validation = ["Ajani", "Aminatou", "Angrath", "Arlinn", "Ashiok",
      "Basri", "Bolas", "Calix", "Chandra", "Dack", "Daretti", "Davriel", "Domri",
      "Dovin", "Elspeth", "Estrid", "Freyalise", "Garruk", "Gideon", "Huatli",
      "Jace", "Jaya", "Karn", "Kasmina", "Kaya", "Kiora", "Koth", "Liliana",
      "Lukka", "Nahiri", "Narset", "Niko", "Nissa", "Nixilis", "Oko", "Ral",
      "Rowan", "Saheeli", "Samut", "Sarkhan", "Serra", "Sorin", "Tamiyo",
      "Teferi", "Teyo", "Tezzeret", "Tibalt", "Tyvar", "Ugin", "Venser", "Vivien",
      "Vraska", "Will", "Windgrace", "Wrenn", "Xenagos", "Yanggu", "Yanling",
      "B.O.B.", "Urza", "Clue", "Contraption", "Equipment", "Food", "Fortification",
      "Gold", "Treasure", "Vehicle", "Aura",	"Cartouche", "Curse", "Rune", "Saga",
      "Shrine", "Plains", "Island", "Swamp", "Mountain", "Forest", "Desert", "Gate",
      "Lair", "Locus", "Urza's", "Mine", "Power-Plant", "Tower", "Adventure",
      "Arcane", "Trap", "Aetherborn", "Ally", "Angel", "Antelope", "Ape", "Archer",
      "Archon", "Army", "Artificer", "Assassin", "Assembly-Worker", "Atog",
      "Aurochs", "Avatar", "Azra", "Badger", "Barbarian", "Basilisk", "Bat",
      "Bear", "Beast", "Beeble", "Berserker", "Bird",	"Blinkmoth", "Boar",
      "Bringer", "Brushwagg", "Camarid", "Camel", "Caribou", "Carrier", "Cat",
      "Centaur", "Cephalid", "Chimera", "Citizen", "Cleric", "Cockatrice",
      "Construct", "Coward", "Crab", "Crocodile", "Cyclops", "Dauthi", "Demigod",
      "Demon", "Deserter", "Devil", "Dinosaur", "Djinn", "Dog", "Dragon", "Drake",
      "Dreadnought", "Drone", "Druid", "Dryad", 	"Dwarf", "Efreet", "Egg",
      "Elder", "Eldrazi", "Elemental", "Elephant", "Elf", "Elk", "Eye", "Faerie",
      "Ferret", "Fish", "Flagbearer", "Fox", "Frog", "Fungus", "Gargoyle", "Germ",
      "Giant", "Gnome", "Goat", "Goblin", "God", "Golem", "Gorgon", "Graveborn",
      "Gremlin", "Griffin", "Hag", "Harpy", "Hellion", "Hippo", "Hippogriff",
      "Homarid", "Homunculus", "Horror", "Horse", "Human", "Hydra", "Hyena",
      "Illusion", "Imp", "Incarnation", "Insect", "Jackal", "Jellyfish", "Juggernaut",
      "Kavu", "Kirin", "Kithkin", "Knight", "Kobold", "Kor", "Kraken", "Lamia",
      "Lammasu", "Leech", "Leviathan", "Lhurgoyf", "Licid", "Lizard", "Manticore",
      "Masticore", "Mercenary", "Merfolk", "Metathran", "Minion", "Minotaur", "Mole",
      "Monger", "Mongoose", "Monk", "Monkey", "Moonfolk", "Mouse", "Mutant",
      "Myr", "Mystic", "Naga", "Nautilus", "Nephilim", "Nightmare", "Nightstalker",
      "Ninja", "Noble", "Noggle", "Nomad", "Nymph", "Octopus", "Ogre", "Ooze",
      "Orb", "Orc", "Orgg", "Otter", "Ouphe", "Ox", "Oyster", "Pangolin", "Peasant",
      "Pegasus", "Pentavite", "Pest", "Phelddagrif", "Phoenix", "Pilot", "Pincher",
      "Pirate", "Plant", "Praetor", "Prism", "Processor", "Rabbit", "Rat",
      "Rebel", "Reflection", "Rhino", "Rigger", "Rogue", "Sable", "Salamander",
      "Samurai", "Sand", "Saproling", "Satyr", "Scarecrow", "Scion", "Scorpion",
      "Scout", "Sculpture", "Serf", "Serpent", "Servo", "Shade", "Shaman",
      "Shapeshifter", "Shark", "Sheep", "Siren", "Skeleton", "Slith", "Sliver",
      "Slug", "Snake", "Soldier", "Soltari", "Spawn", "Specter", "Spellshaper",
      "Sphinx", "Spider", "Spike", "Spirit", "Splinter", "Sponge", "Squid",
      "Squirrel", "Starfish", "Surrakar", "Survivor", "Tentacle", "Tetravite",
      "Thalakos", "Thopter", "Thrull", "Treefolk", "Trilobite", "Triskelavite",
      "Troll", "Turtle", "Unicorn", "Vampire", "Vedalken", "Viashino", "Volver",
      "Wall", "Warlock", "Warrior", "Weird", "Werewolf", "Whale", "Wizard", "Wolf",
      "Wolverine", "Wombat", "Worm", "Wraith", "Wurm", "Yeti", "Zombie", "Zubera"]
    @inclusion_validation = ['I', 'E']
    @repeat_validation = ['Y', 'N']
  end

  public

  def chage_term
    @current_term = @term.shift
    @term.push(@current_term)
  end

  def build_link(term, inclusion)
    @link = @link + "&subtype=" if @current_term == "Subtype"
    @link = @link + "+#{inclusion}[\"#{term}\"]"
  end

  def term_validation(term)
    check = false
    check = if @current_term == 'Type'
              @type_validation.include? term
            elsif @current_term == 'Supertype'
              @supertype_validation.include? term
            else
              @subtype_validation.include? term
            end
    check
  end
end

search = Search.new

loop do
  flag = true
  term = ''
  inclusion = ''
  repeat = ''
  search.chage_term
  while flag == true do
    puts
    loop do
      print "Chose a Card #{search.current_term}: "
      term = gets.chomp.downcase.capitalize
      break if search.term_validation(term)
      puts
      puts "Not a valid Card #{search.current_term}. "
      puts
    end
    loop do
      print 'Include or Exclude from the search? (I/E): '
      inclusion = gets.chomp.upcase
      if search.inclusion_validation.include? inclusion
        inclusion = (inclusion == 'E') ? '!':''
        break
      else
        puts
        puts 'Invalid Input'
        puts
      end
    end
    loop do
      print "Want to add another? (Y/N): "
      repeat = gets.chomp.upcase
      if search.repeat_validation.include? repeat
        break
      else
        puts
        puts 'Invalid Input'
        puts
      end
    end
    flag = false if repeat == "N"
    search.build_link(term, inclusion)
  end
  break if search.current_term == "Subtype"
end

puts search.link

name_array = []
link_array = []
set_array = []
type_array = []
subtype_array = []

doc_1 = Nokogiri::HTML(URI.open(search.link))

doc_1.xpath('//td//a').each do |content|
  name_array << content.content unless content.content == ""
end

doc_1.xpath('//td//div//a//@href').each do |link|
  link_array << link.content unless link.content == ""
end

link_2 = "https://gatherer.wizards.com/Pages/Card/Details.aspx?multiverseid=#{link_array[1]}"
doc_2 = Nokogiri::HTML(URI.open(link_2))

doc_2.css("#ctl00_ctl00_ctl00_MainContent_SubContent_SubContent_currentSetSymbol a").each do |link|
  set_array << link.content
end

doc_3 = Nokogiri::HTML(URI.open('https://gatherer.wizards.com/Pages/Advanced.aspx'))

doc_3.css("#autoCompleteSourceBoxtypeAddText3_InnerTextBoxcontainer a").each do |link|
  type_array << link.content
end

doc_3.css("#autoCompleteSourceBoxsubtypeAddText4_InnerTextBoxcontainer a").each do |link|
  subtype_array << link.content
end

puts
puts subtype_array
