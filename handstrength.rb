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


def winning_hand(cards)
    return "ROYAL FLUSH!" if is_straight_flush?(cards) == "royal flush"
    return "STRAIGHT FLUSH!" if is_straight_flush?(cards)
    return "FOUR OF A KIND!" if is_four_of_a_kind?(cards)
    return "FULL HOUSE!" if is_full_house?(cards)
    return "FLUSH!" if is_flush?(cards)
    return "STRAIGHT!" if is_straight?(cards)
    return "THREE OF A KIND!" if is_three_of_a_kind?(cards)
    return "TWO PAIR!" if is_two_pair?(cards)
    return "PAIR!" if is_pair?(cards)
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
        if best_hand_score == 9 || best_hand_score == 5
            best_straight(*best_hand)
        elsif best_hand_score == 4
            best_three_of_a_kind(*best_hand)
        elsif best_hand_score == 7
            best_full_house(*best_hand)
        elsif best_hand_score == 8
            best_four_of_a_kind(*best_hand)
        else best_hand
        end
    else best_hand
    end

end