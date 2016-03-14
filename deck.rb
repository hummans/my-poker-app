class Deck
  
  attr_accessor :shuffled
  
  META_DECK = ("2".."14").flat_map { |rank| ("a".."d").map { |suit| (rank + suit) } }

  def initialize
    @shuffled = META_DECK.shuffle
  end
end