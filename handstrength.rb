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