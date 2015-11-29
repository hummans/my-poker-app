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



# shuffles the deck for play

deck = meta_deck.shuffle



# the cards you are dealt from the shuffled deck (for 5-card stud)

my_holdings = [deck.pop, deck.pop, deck.pop, deck.pop, deck.pop]


=beginning
methods for determining the strength of hands. <r> stands for "rank" and is both 
invoked as a method and declared as a variable when we are concerned with the 
rank (or integer property) of the cards. <s> stands for "suit" and is both invoked 
as a method and declared as a variable when we are concerned with the suit (or
letter property) of the cards.
=end



# this method isolates the cards' "rank" (integer properties) by mapping it onto a new array

def r(cards)
    cards.map { |x| x[0..-2].to_i }.sort
end



# this method isolates the cards' "suit" (letter properties) by mapping it onto a new array

def s(cards)
    cards.map { |x| x[-1] }
end


def which_rank_occurs_n_times?(cards, n)

    n_occurrences_hash = Hash.new(0)
    cards.each do |rank|
        n_occurrences_hash[rank] += 1
    end

    n_occurrences_hash.each do |rank, occurrence_number|
        return rank if occurrence_number == n
    end
end
