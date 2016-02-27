META_DECK = ("2".."14").flat_map { |rank| ("a".."d").map { |suit| (rank + suit) } }

def give_me_results(n)
    
  results = Hash.new(0)
    
  n.times do
    draw = []
    deck = META_DECK.shuffle
    7.times {draw << deck.pop}
    results[winning_hand(best_hand(all_hands_from_cards(draw)))] += 1
  end
  
  results.each { |a,b| puts "#{a} hands occurred #{(b / n.to_f) * 100}% of the time" }
end

def full_table_sample(n)
    
	all_results = Hash.new(0)

	n.times do
        
    deck = META_DECK.shuffle

    result = []
    
    hands = []
    
    community_cards = []
    
    player_holdings = []
        
    8.times { player_holdings << [deck.pop, deck.pop] }
    
    5.times do
    	community_cards << deck.pop
    end
    
    player_holdings.each do |x|
    	hands << (x + community_cards)
    end
    
    hands.each do |x|
    	a = best_hand(all_hands_from_cards(x))
    	
    	a.length == 1 ? result << a.flatten : result << a[0].flatten
    end
    
    all_results[winning_hand(best_hand(result))] += 1
  end
    
	all_results.each { |a,b| puts "#{a} hands occurred #{(b / n.to_f) * 100}% of the time" }
end