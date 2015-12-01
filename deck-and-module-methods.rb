=begin 
Generates an array which contains 2..14 four times with a..d appended 
to each integer.to_s like so: ["2a","2b","2c","2d"..."14a","14b","14c","14d"]
This represents the unshuffled deck object which corresponds to a conventional
playing card deck. Each card has two vital properties: "rank" and "suit."
2..14 denote the "rank" (integer property) of the card, and a..d denote the 
"suit" (letter property) of the card. 
=end

arr = ((2..14).to_a * 4).sort

meta_deck = arr.map.with_index do |x,y|
    
    if y % 4 == 0
        x.to_s + "a"
    elsif (y-1) % 4 == 0
        x.to_s + "b" 
    elsif (y-2) % 4 == 0
        x.to_s + "c"
    else 
        x.to_s + "d"
    end
end
#----------------------------------------------------#
#----------------------------------------------------#


=begin
We need to represent cards as ordered index integers from 0..51 for properly sorting
and generating all possible hands from a six-card or seven-card combination (i.e. 
"the turn" or "the river") To achieve this, we must first generate a hash from the 
meta_deck array construct.
=end


meta_deck_hash = Hash.new

hash_value = 0

meta_deck.map do |card|
    
    meta_deck_hash[card] = hash_value
    
    hash_value += 1
end




# This assignment shuffles the meta_deck for play.

deck = meta_deck.shuffle


=begin
This represents the cards you are dealt from the shuffled deck (for 5-card stud). At this 
juncture, it is currently commented out due to irrelevancy.

my_holdings = [deck.pop, deck.pop, deck.pop, deck.pop, deck.pop]
=end


##########################################################


=begin
These helper methods isolate the cards' "rank" (integer properties) and "suit" (letter 
properties) by mapping them onto a new array. They are crucial to the control flow of this 
application as they are used in virtually all hand strength and hand comparison methods.
=end

def r(cards)
    cards.map { |x| x[0..-2].to_i }.sort
end


def s(cards)
    cards.map { |x| x[-1] }
end


###########################################################


=begin
This helper method is used in all hands of type <pair; two-pair; three-of-a-kind; full house; 
or four-of-a-kind> when we are concerned with isolating or excising the part of the hand which
contains multiple occurrences of the same rank.
=end

def which_rank_occurs_n_times?(cards, n)
    
    arr = []

    n_occurrences_hash = Hash.new(0)
    cards.each do |rank|
        n_occurrences_hash[rank] += 1
    end

    n_occurrences_hash.each do |rank, occurrence_number|
        
        if occurrence_number == n
            arr << rank
        end
    end
    
    if arr.length == 1
        arr[0]
    
    else arr
    
    end
end

#which_rank_occurs_n_times?([3,6,6,7], 2)


#This helper method is particularly useful for the single-pair hand.


def slice_pair(cards)
    
    arr = []
    
    cards.each do |rank|
        
       arr << rank if rank != which_rank_occurs_n_times?(cards, 2)
   end
   
   arr
end



def convert_cards_into_indx_values(cards)

#-------------------------------------------#
#-------------------------------------------#   
    
    arr = ((2..14).to_a * 4).sort

    meta_deck = arr.map.with_index do |x,y|
    
        if y % 4 == 0
            x.to_s + "a"
        elsif (y-1) % 4 == 0
            x.to_s + "b" 
        elsif (y-2) % 4 == 0
            x.to_s + "c"
        else 
            x.to_s + "d"                        ##THIS IS A REDUNDANCY PROBLEM;
        end
    end                                         ##ALREADY DECLARED IN GLOBAL ENVIRONMENT;

    meta_deck_hash = Hash.new

    i = 0

    meta_deck.map do |card|
    
    meta_deck_hash[card] = i
    
    i+=1
    end
 
 #---------------------------------------------#
 #---------------------------------------------#   
    
    cards.map do |card|
    
        card = meta_deck_hash[card]
        
    end
end

#convert_cards_into_int_values(["10a","11b"])

def all_hands_from_cards(cards)

#################################################
#################################################
    
    arr = ((2..14).to_a * 4).sort

    meta_deck = arr.map.with_index do |x,y|
    
        if y % 4 == 0
            x.to_s + "a"
        elsif (y-1) % 4 == 0
            x.to_s + "b" 
        elsif (y-2) % 4 == 0
            x.to_s + "c"
        else 
            x.to_s + "d"                                ##THIS IS A PROBLEM; SEE ABOVE;
        end
    end

    meta_deck_hash = Hash.new

    i = 0

    meta_deck.map do |card|
    
    meta_deck_hash[card] = i
    
    i+=1
    end

  ################################################
  ################################################
    
    indx_values = convert_cards_into_indx_values(cards)

    all_hands = []
    
    if cards.length == 7

        until all_hands.length == 21

            c = indx_values.shuffle
    
            random_hand = [c.pop, c.pop, c.pop, c.pop, c.pop]
    
            all_hands << random_hand.sort

            all_hands = all_hands.uniq
        end
            
    elsif cards.length == 6
        
        until all_hands.length == 6
    
            c = indx_values.shuffle
    
            random_hand = [c.pop, c.pop, c.pop, c.pop, c.pop]
    
            all_hands << random_hand.sort

            all_hands = all_hands.uniq
        end
    end

    all_hands.map do |this_hand|
        
        this_hand.map do |card|
            
            meta_deck_hash.key(card)
        end
    end
        
end

#all_hands_from_cards(["2a","4b","5c","6d","7a","4d","5d"])