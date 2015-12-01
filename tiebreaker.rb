=begin
When any 2 or more hands result in the same type of hand (e.g. both are full houses), we
must use tie-breaker methods to deduce which hand/s is/are best. The input parameter is
always a single array which stores at least 2 sub-arrays. The sub-arrays represent hands
(of the same type) and are composed of cards from the meta_deck. Also worth noting is the 
frequent use of the variables <this_hand> and <this_hand_unrefined>. Since the input params
for all of the below methods always contain hands of cards with the "suit" AND "rank" 
properties intact, we must oftentimes isolate one or the other. <this_hand_unrefined> refers 
to when the hand has not yet had its cards' properties isolated. These two variables in fact 
exist as corollaries to the helper methods :r and :s.
=end
    
end

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

        bestest_hand = []

        highest_rank = 0

        best_hand.each do |this_hand_unrefined|

            this_hand = r(this_hand_unrefined)

            this_hand.each do |rank|

                if rank != which_rank_occurs_n_times?(this_hand, 4) && rank > highest_rank
                    highest_rank = rank
                    bestest_hand = [this_hand_unrefined]
                
                elsif rank != which_rank_occurs_n_times?(this_hand, 4) && rank == highest_rank
                    bestest_hand << this_hand_unrefined
                end
            
            end
        
        end
        
        bestest_hand
    
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

        bestest_hand = []

        highest_rank = 0

        best_hand.each do |this_hand_unrefined|

            this_hand = r(this_hand_unrefined)

            if which_rank_occurs_n_times?(this_hand, 2) > highest_rank
                bestest_hand = [this_hand_unrefined]
                highest_rank = which_rank_occurs_n_times?(this_hand, 2)
            
            elsif which_rank_occurs_n_times?(this_hand, 2) == highest_rank
                bestest_hand << this_hand_unrefined
            end
        
        end
        
        bestest_hand
    
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