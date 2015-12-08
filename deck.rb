class Deck
    
    attr_reader :deck
    
    META_DECK = (2..14).to_a.map { |rank| ("a".."d").to_a.map { |suit| (rank.to_s + suit) } }.flatten

    def initialize
        @deck = META_DECK.shuffle
    end

    def deal
    	[@deck.pop, @deck.pop]
    end
    
    def flop
        [@deck.pop, @deck.pop, @deck.pop]
    end
    
    def turn
        [flop, @deck.pop].flatten
    end
    
    def river
        [turn, @deck.pop ].flatten
    end

end