module handCalculator

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

#######################################################################


def all_hands_from_cards(cards)

    
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


=begin
We need to represent cards as ordered index integers from 0..51 for properly sorting
and generating all possible hands from a six-card or seven-card combination (i.e. 
"the turn" or "the river") To achieve this, we must first generate a hash from the 
meta_deck array object.
=end

#########################################    
    
    meta_deck_hash = Hash.new

    i = 0

    meta_deck.map do |card|
    
        meta_deck_hash[card] = i
    
        i+=1
    
    end

##########################################

    indx_values = cards.map do |card|
    
        card = meta_deck_hash[card]
    end

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



=begin
methods for determining the strength of hands. <r> stands for "rank" and is both 
invoked as a method and declared as a variable when we are concerned with the 
rank (or integer property) of the cards. <s> stands for "suit" and is both invoked 
as a method and declared as a variable when we are concerned with the suit (or
letter property) of the cards.
=end

def is_straight_flush?(cards)
    
    s = s(cards)
    
    r = r(cards)

    if s[0] == s[1] && s[1] == s[2] && s[2] == s[3] && s[3] == s[4]
        if r[4] - r[3] == 1 && r[3] - r[2] == 1 && r[2] - r[1] == 1 && r[1] - r[0] == 1 &&  r[3] == 13
            "royal flush"
        elsif r[4] - r[3] == 1 && r[3] - r[2] == 1 && r[2] - r[1] == 1 && r[1] - r[0] == 1
            true
        elsif r[3] - r[2] == 1 && r[2] - r[1] == 1 && r[1] - r[0] == 1 && r[4] - r[0] == 12 && r[4] == 14
            true
        else false
        end
    else false
    end
end


def is_four_of_a_kind?(cards)
    
    r = r(cards)
    
    if (r[0] == r[1] && r[1] == r[2] && r[2] == r[3]) || (r[1] == r[2] && r[2] == r[3] && r[3] == r[4])
        true
    else false
    end
end


def is_full_house?(cards)
    
    r = r(cards)

    if ((r[0] == r[1] && r[1] == r[2]) && r[3] == r[4]) || (r[0] == r[1] && (r[2] == r[3] && r[3] == r[4]))
        true
    else false
    end
end


def is_flush?(cards)
    
    s = s(cards)
    
    if s[0] == s[1] && s[1] == s[2] && s[2] == s[3] && s[3] == s[4]
        true
    else false
    end
end


def is_straight?(cards)

    r = r(cards)
    
    if r[4] - r[3] == 1 && r[3] - r[2] == 1 && r[2] - r[1] == 1 && r[1] - r[0] == 1
        true
    elsif r[3] - r[2] == 1 && r[2] - r[1] == 1 && r[1] - r[0] == 1 && r[4] - r[0] == 12 && r[4] == 14
        true
    else false
    end
end


def is_three_of_a_kind?(cards)
    
    r = r(cards)
    
    if (r[0] == r[1] && r[1] == r[2]) || (r[1] == r[2] && r[2] == r[3]) || (r[2] == r[3] && r[3] == r[4])
        true
    else false
    end
end


def is_two_pair?(cards)
    
    r = r(cards)
    
    if (r[0] == r[1] && r[2] == r[3]) || (r[1] == r[2] && r[3] == r[4]) || (r[0] == r[1] && r[3] == r[4])
        true
    else false
    end
end


def is_pair?(cards)
    
    r = r(cards)
    
    if r[0] == r[1] || r[1] == r[2] || r[2] == r[3] || r[3] == r[4]
        true
    else false
    end
end


=begin
When any 2 or more hands result in the same type of hand (e.g. both are full houses), we
must use tie-breaker methods to deduce which hand/s is/are best. The input parameter is
always a single array which stores at least 2 sub-arrays. The sub-arrays represent hands
(of the same hand strength type) and are composed of cards from the meta_deck. Also worth 
noting is the frequent use of the variables <this_hand> and <this_hand_unrefined>. Since 
the input params for all of the below methods always contain hands of cards with the "suit" 
AND "rank" properties intact, we must oftentimes isolate one or the other. <this_hand_unrefined> 
refers to when the hand has not yet had its cards' properties isolated (the aforementioned
variables exist as corollaries to the helper methods :r and :s, in fact).
=end

def best_four_of_a_kind(hands)

    best_hand = []

    highest_rank = 0

    hands.each do |this_hand_unrefined|

        this_hand = r(this_hand_unrefined)

        if which_rank_occurs_n_times?(this_hand, 4) > highest_rank
            best_hand = [this_hand_unrefined]
            highest_rank = which_rank_occurs_n_times?(this_hand, 4)
        
        elsif which_rank_occurs_n_times?(this_hand, 4) == highest_rank
            best_hand << this_hand_unrefined
        end
    
    end

    if best_hand.length > 1

        highest_rank = 0

        best_hand.each do |this_hand_unrefined|

            this_hand = r(this_hand_unrefined)

            this_hand.each do |rank|

                if rank != which_rank_occurs_n_times?(this_hand, 4) && rank > highest_rank
                    highest_rank = rank
                    best_hand = [this_hand_unrefined]
                
                elsif rank != which_rank_occurs_n_times?(this_hand, 4) && rank == highest_rank
                    best_hand << this_hand_unrefined
                end
            
            end
        
        end
        
        best_hand
    
    else best_hand
    
    end
end


def best_full_house(hands)

    best_hand = []

    highest_rank = 0

    hands.each do |this_hand_unrefined|

        this_hand = r(this_hand_unrefined)
        
        if which_rank_occurs_n_times?(this_hand, 3) > highest_rank
            best_hand = [this_hand_unrefined]
            highest_rank = which_rank_occurs_n_times?(this_hand, 3)
        
        elsif which_rank_occurs_n_times?(this_hand, 3) == highest_rank
            best_hand << this_hand_unrefined
        end
    
    end

    if best_hand.length > 1

        highest_rank = 0

        best_hand.each do |this_hand_unrefined|

            this_hand = r(this_hand_unrefined)

            if which_rank_occurs_n_times?(this_hand, 2) > highest_rank
                best_hand = [this_hand_unrefined]
                highest_rank = which_rank_occurs_n_times?(this_hand, 2)
            
            elsif which_rank_occurs_n_times?(this_hand, 2) == highest_rank
                best_hand << this_hand_unrefined
            end
        
        end
        
        best_hand
    
    else best_hand
    
    end
end

=begin
def best_flush(hands)
   
    best_hand = []
   
    highest = 0
    second = 0
    third = 0
    fourth = 0
    fifth = 0
   
    hands.each do |this_hand_unrefined|
       
        this_hand = r(this_hand_unrefined)
       
        if this_hand[4] > highest
            highest = this_hand[4]
            best_hand = [this_hand_unrefined]
       
        elsif this_hand[4] == highest
            best_hand << this_hand_unrefined
        end
    end
   
    if best_hand.length > 1
       
        best_hand.each do |this_hand_unrefined|
           
            this_hand = r(this_hand_unrefined)
           
            if this_hand[3] > second
                second = this_hand[3]
                best_hand = [this_hand_unrefined]
           
            elsif this_hand[3] == second
                best_hand << this_hand_unrefined
            end
        end
       
        if best_hand.length > 1
           
            best_hand.each do |this_hand_unrefined|
           
                this_hand = r(this_hand_unrefined)
           
                if this_hand[2] > third
                    third = this_hand[2]
                    best_hand = [this_hand_unrefined]
               
                elsif this_hand[2] == third
                    best_hand << this_hand_unrefined
                end
            end
           
            if best_hand.length > 1
               
                best_hand.each do |this_hand_unrefined|
                   
                    this_hand = r(this_hand_unrefined)
           
                    if this_hand[1] > fourth
                        fourth = this_hand[1]
                        best_hand = [this_hand_unrefined]
                   
                    elsif this_hand[1] == fourth
                        best_hand << this_hand_unrefined
                    end
                end
           
                if best_hand.length > 1
                   
                    best_hand.each do |this_hand_unrefined|
                   
                    this_hand = r(this_hand_unrefined)
           
                        if this_hand[0] > fifth
                            fifth = this_hand[0]
                            best_hand = [this_hand_unrefined]
                       
                        elsif this_hand[0] == fifth
                            best_hand << this_hand_unrefined
                        end
                    end
               
                    best_hand
               
                else best_hand
                end
           
            else best_hand
            end
           
        else best_hand
        end
   
    else best_hand
    end
end
=end


def best_flush(hands, n = 4 )
   
    best_hand = []
   
    highest = 0
 
    hands.each do |this_hand_unrefined|
       
        this_hand = r(this_hand_unrefined)
       
        if this_hand[n] > highest
            highest = this_hand[n]
            best_hand = [this_hand_unrefined]
       
        elsif this_hand[n] == highest
            best_hand << this_hand_unrefined
        end
    end
   
    if best_hand.length == 1 || n==0
        best_hand
   
    else best_flush(best_hand, n -= 1)
    end
end
 
#best_flush([["13a","11a","10a","9a","8a"],["13a","11a","10a","9a","7a"]])


=begin
The only relevant criterion for determining the best flush or straight
is the sum of the ranks (or integer properties) of any given hand. 
In summing the integer properties, we must be careful to make an
exception for when the ace is part of the low straight. If this is
the case, then we reassign a rank value of 1 to it for our final summation.
=end


def best_straight(hands)
    
    highest_rank_sum = 0
    
    best_hand = []
    
    hands.each do |this_hand|

        ## reassign the rank value of the ace when it is part of the low straight ##

    
        this_hand[4] = "1" if r(this_hand) == [2,3,4,5,14]

        ##    ##     ##      ##      ##      ##
    
        rank_sum = r(this_hand).inject(:+)
    
        if rank_sum > highest_rank_sum
            highest_rank_sum = rank_sum
            best_hand = [this_hand]
    
        elsif rank_sum == highest_rank_sum
            best_hand << this_hand
        end
    
    end
    
    best_hand

end

# best_straight(["18a","4a","12b","13a","9d"], ["29a","8c","8b","9a","2d"]) #returns both

# best_straight(["2a","3a","4a","5a","14a"], ["2a","3a","4a","5a","6a"]) #returns the second arr


def best_three_of_a_kind(hands)

    best_hand = []

    highest_rank = 0
    

    hands.each do |this_hand_unrefined|
        
        this_hand = r(this_hand_unrefined)
        
        if which_rank_occurs_n_times?(this_hand, 3) > highest_rank
            best_hand = [this_hand_unrefined]
            highest_rank = which_rank_occurs_n_times?(this_hand, 3)
        
        elsif which_rank_occurs_n_times?(this_hand, 3) == highest_rank
            best_hand << this_hand_unrefined
        
        end
    
    end

    
    if best_hand.length > 1
        
        the_highest = 0
        the_second_highest = 0
        
        best_hand.each do |this_hand_unrefined|
            
            this_hand = r(this_hand_unrefined)
            
            highest = 0
            second_highest = 0
            
            this_hand.each do |rank|
                
                if rank != which_rank_occurs_n_times?(this_hand, 3) && rank > highest
                    second_highest = highest
                    highest = rank
                
                elsif rank != which_rank_occurs_n_times?(this_hand, 3) && rank < highest
                    second_highest = rank
                end
            
            end
            
            if highest > the_highest
                the_highest = highest
                the_second_highest = second_highest
                best_hand = [this_hand_unrefined]
                
            elsif highest == the_highest && second_highest > the_second_highest
                the_second_highest = second_highest
                best_hand = [this_hand_unrefined]
                
            elsif highest == the_highest && second_highest == the_second_highest
                best_hand << this_hand_unrefined
            end
        
        end
        
        best_hand
    
    else best_hand
    
    end
end
   
#best_three_of_a_kind(["11a","11b","11c","12a","10b"], ["11d","11b","11c","10b","12a"]) #returns both
   
#best_three_of_a_kind(["11a","11b","11c","9a","12b"],["11d","11b","11c","10b","12a"]) #returns the second arr

def best_two_pair(hands)
    
    best_hand = []
    
    top_pair_rank = 0
    
    bottom_pair_rank = 0
    
    kicker = 0
    
    hands.each do |this_hand_unrefined|
        
        this_hand = r(this_hand_unrefined)
        
        if (which_rank_occurs_n_times?(this_hand, 2)).max > top_pair_rank
            top_pair_rank = (which_rank_occurs_n_times?(this_hand, 2)).max
            best_hand = [this_hand_unrefined]
        
        elsif (which_rank_occurs_n_times?(this_hand, 2)).max == top_pair_rank
            best_hand << this_hand_unrefined
        end
    end
            
    if best_hand.length > 1
        
        best_hand.each do |this_hand_unrefined|
        
            this_hand = r(this_hand_unrefined)
        
            if (which_rank_occurs_n_times?(this_hand, 2)).min > bottom_pair_rank
                bottom_pair_rank = (which_rank_occurs_n_times?(this_hand, 2)).min
                best_hand = [this_hand_unrefined]
            
            elsif (which_rank_occurs_n_times?(this_hand, 2)).min == bottom_pair_rank
                best_hand << this_hand_unrefined
            end
        end
    
        if best_hand.length > 1
            
            best_hand.each do |this_hand_unrefined|
            
                this_hand = r(this_hand_unrefined)
            
                this_hand.each do |rank|
                
                    if rank > kicker && !(which_rank_occurs_n_times?(this_hand, 2).include?(rank))
                        kicker = rank
                        best_hand = [this_hand_unrefined]
                    
                    elsif rank > kicker && !(which_rank_occurs_n_times?(this_hand, 2).include?(rank))
                        best_hand << this_hand_unrefined
                    end
                end
            
            end
            best_hand
        else best_hand
        end
        
    else best_hand
    end
end

#which_rank_occurs_n_times?([2,3,3,2,5], 2).min

#best_two_pair([["13a","13b","10a","10b","14a"],["10a","10b","13b","13c","9a"]]) #returns the first arr

=begin
def best_pair(hands)
    
    best_hand = []
    
    top_pair = 0
    
    first_kicker = 0
    
    second_kicker = 0
    
    third_kicker = 0
    
    hands.each do |this_hand_unrefined|
        
        
        this_hand = r(this_hand_unrefined)
        
        if which_rank_occurs_n_times?(this_hand, 2) > top_pair
            top_pair = which_rank_occurs_n_times?(this_hand, 2)
            best_hand = [this_hand_unrefined]
        
        elsif which_rank_occurs_n_times?(this_hand, 2) == top_pair
            best_hand << this_hand_unrefined
        end
        
    end
    
    
    
    if best_hand.length > 1
        
        best_hand.each do |this_hand_unrefined|
            
            this_hand = r(this_hand_unrefined)
            
            nonpair_cards =  slice_pair(this_hand)
            
            if nonpair_cards[2] > first_kicker
                first_kicker = nonpair_cards[2]
                best_hand = [this_hand_unrefined]
            
            elsif nonpair_cards[2] == first_kicker
                best_hand << this_hand_unrefined
            end
        end
        
        if best_hand.length > 1
            
            best_hand.each do |this_hand_unrefined|
                
                this_hand = r(this_hand_unrefined)
                
                nonpair_cards = slice_pair(this_hand)
                
                if nonpair_cards[1] > second_kicker
                    second_kicker = nonpair_cards[1]
                    best_hand = [this_hand_unrefined]
                
                elsif nonpair_cards[1] == second_kicker
                    best_hand << this_hand_unrefined
                end
            end
            
            if best_hand.length > 1
                
                best_hand.each do |this_hand_unrefined|
                    
                    this_hand = r(this_hand_unrefined)
                    
                    nonpair_cards = slice_pair(this_hand)
                    
                    if nonpair_cards[0] > third_kicker
                        third_kicker = nonpair_cards[0]
                        best_hand = [this_hand_unrefined]
                        
                    elsif nonpair_cards[0] == third_kicker
                        best_hand << this_hand_unrefined
                    end
                end
                best_hand
                
            else best_hand
            end
            
        else best_hand
        end
    
    else best_hand
    end
end

#best_pair([["14a","14b","13a","10b","3a"],["14a","13b","14b","10c","4a"]]) #returns the second arr
=end

def best_pair(hands)
    
    def assess_the_kickers(hands, i = 2)
        
        best_hand = []
        
        kicker = 0
        
        hands.each do |this_hand_unrefined|
            
            this_hand = r(this_hand_unrefined)
            
            nonpair_cards = slice_pair(this_hand)
            
            if nonpair_cards[i] > kicker
                kicker = nonpair_cards[i]
                best_hand = [this_hand_unrefined]
            
            elsif nonpair_cards[i] == kicker
                best_hand << this_hand_unrefined
            end
        end
        
        if best_hand.length == 1 || i == 0 
            best_hand
        else assess_the_kickers(best_hand, i -= 1)
        end
    end
    
    best_hand = []
    
    top_pair = 0
    
    hands.each do |this_hand_unrefined|
        
        
        this_hand = r(this_hand_unrefined)
        
        if which_rank_occurs_n_times?(this_hand, 2) > top_pair
            top_pair = which_rank_occurs_n_times?(this_hand, 2)
            best_hand = [this_hand_unrefined]
        
        elsif which_rank_occurs_n_times?(this_hand, 2) == top_pair
            best_hand << this_hand_unrefined
        end
        
    end
    
    if best_hand.length == 1
        best_hand
    else
        assess_the_kickers(best_hand)
    end
end

best_pair([["14a","14b","11a","10b","6a"],["14a","12b","14b","10c","13a"]]) #returns the second arr


def best_air(hands, n = 4)
    
    best_hand = []
    
    highest_rank = 0
    
    hands.each do |this_hand_unrefined|
        
        this_hand = r(this_hand_unrefined)
        
        if this_hand[n] > highest_rank
            highest_rank = this_hand[n]
            best_hand = [this_hand_unrefined]
        
        elsif this_hand[n] == highest_rank
            best_hand << this_hand_unrefined
        end
    end
    
    return best_hand if best_hand.length == 1 || n == 0
    
    best_air(best_hand, n -= 1)
    
end

#best_air([["4a","13b","12a","11b","10a"],["7a","13b","12b","11c","10a"],["3a","13b","12b","11b","10a"]]) #returns second arr


def winning_hand(the_hand)
    
    if the_hand.length == 1
        the_hand = the_hand.flatten
    
    else the_hand = the_hand[0]
    
    end
    return "ROYAL FLUSH!" if is_straight_flush?(the_hand) == "royal flush"
    return "STRAIGHT FLUSH!" if is_straight_flush?(the_hand)
    return "FOUR OF A KIND!" if is_four_of_a_kind?(the_hand)
    return "FULL HOUSE!" if is_full_house?(the_hand)
    return "FLUSH!" if is_flush?(the_hand)
    return "STRAIGHT!" if is_straight?(the_hand)
    return "THREE OF A KIND!" if is_three_of_a_kind?(the_hand)
    return "TWO PAIR!" if is_two_pair?(the_hand)
    return "PAIR!" if is_pair?(the_hand)
    return "COMPLETE AIR"
end


def evaluate_hand(cards)
    return 10 if is_straight_flush?(cards) == "royal flush"
    return 9 if is_straight_flush?(cards)
    return 8 if is_four_of_a_kind?(cards)
    return 7 if is_full_house?(cards)
    return 6 if is_flush?(cards)
    return 5 if is_straight?(cards)
    return 4 if is_three_of_a_kind?(cards)
    return 3 if is_two_pair?(cards)
    return 2 if is_pair?(cards)
    return 1
end


def best_hand(hands)

    best_hand = []
    best_hand_score = 0

    hands.each do |this_hand|
       if evaluate_hand(this_hand) > best_hand_score
            best_hand = [this_hand]
            best_hand_score = evaluate_hand(this_hand)
        elsif evaluate_hand(this_hand) == best_hand_score
            best_hand << this_hand
        end
    end
    if best_hand.length > 1
        if best_hand_score == 1
            best_air(best_hand)
        elsif best_hand_score == 2
            best_pair(best_hand)
        elsif best_hand_score == 3
            best_two_pair(best_hand)
        elsif best_hand_score == 4
            best_three_of_a_kind(best_hand)
        elsif best_hand_score == 5 || best_hand_score == 9
            best_straight(best_hand)
        elsif best_hand_score == 6
            best_flush(best_hand)
        elsif best_hand_score == 7
            best_full_house(best_hand)
        elsif best_hand_score == 8
            best_four_of_a_kind(best_hand)
        else best_hand
        end
    else best_hand
    end

end

#winning_hand(best_hand(all_hands_from_cards([deck.pop,deck.pop,deck.pop,deck.pop,deck.pop,deck.pop,deck.pop])))

#winning_hand(best_hand(all_hands_from_cards(["10b","12d","10d","10c","9b","9c","10a"])))