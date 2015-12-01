def give_me_a_hand(cards)

  collection = []
 
  deck = []

  while collection.length < 10_000

    deck = cards.shuffle

    my_holdings = [deck.pop, deck.pop, deck.pop, deck.pop, deck.pop]
    
      collection << my_holdings
    end
    collection
end


def check_royal(hands)
  
  i = 0
  
  while i < deck.length
      if is_straight_flush?(hands[i]) == "royal flush"
        return true
      end
    i+=1
  end
end

#check_royal(give_me_a_hand(meta_deck))

#best_hand(give_me_a_hand(meta_deck))

#best_hand(all_hands_from_cards(["5a","6b","13a","13b","4a","2a","3b"]))

#winning_hand(best_hand(all_hands_from_cards([deck.pop,deck.pop,deck.pop,deck.pop,deck.pop,deck.pop,deck.pop])))

#winning_hand(best_hand(all_hands_from_cards(["5b","5d","5a","4b","3a","7a","8a"])))