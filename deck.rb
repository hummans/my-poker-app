class Deck

    require_relative "hand_calculator"

    include HandCalculator
    
    attr_reader :deck
    
    META_DECK = (2..14).flat_map { |rank| ("a".."d").map { |suit| (rank.to_s + suit) } }

    def initialize
        @deck = META_DECK.shuffle
    end
    
    def draw(n)
        cards = []
        n.times { cards << @deck.pop }
        cards
    end

end