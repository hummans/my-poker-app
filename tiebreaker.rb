def best_four_of_a_kind(*hands)

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
                    bestest_hand = this_hand_unrefined
                
                elsif rank != which_rank_occurs_n_times?(this_hand, 4) && rank == highest_rank
                    bestest_hand << this_hand_unrefined
                end
            
            end
        
        end
        
        bestest_hand
    
    else best_hand
    
    end
end


def best_full_house(*hands)

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


=beginning
The only relevant criterion for determining the best flush or straight
is the sum of the ranks (or integer properties) of any given hand. 
In summing the integer properties, we must be careful to make an
exception for when the ace is part of the low straight. If this is
the case, then we reassign a rank value of 1 to it for our final summation.
=end


def best_straight(*hands)
    
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

# best_flush_or_straight(["18a","4a","12b","13a","9d"], ["29a","8c","8b","9a","2d"]) >>returns both

# best_flush_or_straight(["2a","3a","4a","5a","14a"], ["2a","3a","4a","5a","6a"]) >>returns the second array




def best_three_of_a_kind(*hands)

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
   
# best_three_of_a_kind(["11a","11b","11c","12a","10b"], ["11d","11b","11c","10b","12a"]) >>returns both
   
# best_three_of_a_kind(["11a","11b","11c","9a","12b"],["11d","11b","11c","10b","12a"]) >>returns the second array