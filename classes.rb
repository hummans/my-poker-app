class Player
  attr_accessor :name, :chips, :pocket
  
  def initialize
    @name = ""
    @chips = 1000
    @pocket = []
  end
end

class Deck
  attr_accessor :shuffled
  META_DECK = ("2".."14").flat_map { |rank| ("a".."d").map { |suit| (rank + suit) } }

  def initialize
    @shuffled = META_DECK.shuffle
  end
end

class Game
    
  attr_accessor :game_deck, :pot, :button_player, :other_player, :community_cards, :bp_bet, :op_bet, :current_hand
  
  def initialize
      @game_deck = []
      @pot = 0
      @button_player = Player.new
      @other_player = Player.new
      @community_cards = []
      @bp_bet = 0
      @op_bet = 0
      @current_hand = true
  end
  
  def get_player_names
    if @button_player.name == ""
      puts "What is player 1's name?"
      @button_player.name = gets.chomp
      puts "What is player 2's name?"
      @other_player.name = gets.chomp
    end
  end
  
  def player_deal
     @button_player.pocket = @game_deck.shuffled.slice!(0,2)
     @other_player.pocket = @game_deck.shuffled.slice!(0,2)
  end
  
  def community_deal
    @community_cards.length == 0 ? @community_cards = @game_deck.shuffled.slice!(0,3) : @community_cards << @game_deck.shuffled.shift
  end
  
  def see_river
    if @community_cards.length == 0
      @community_cards << @game_deck.shuffled.slice!(0,5)
    elsif @community_cards.length == 3
      @community_cards << @game_deck.shuffled.slice!(0,2)
    elsif @community_cards.length == 4
      @community_cards << @game_deck.shuffled.slice!(0,1)
    end
  end
  
  def begin_hand
    @game_deck = Deck.new
    @button_player.pocket = @game_deck.shuffled.slice!(0,2)
    @other_player.pocket = @game_deck.shuffled.slice!(0,2)
    @button_player.chips -= 10
    @other_player.chips -= 5
    @bp_bet = 10
    @op_bet = 5
    @pot = 15
    puts "#{@other_player.name}, you are out of position. You have #{@other_player.chips} chips. The pot is #{@pot}. Your pocket cards are #{@other_player.pocket}. #{@bp_bet - @op_bet} chips to call. Type f, c, r, or a"
    action = gets.chomp
    if action == "f"
      fold(@other_player)
      redo
    elsif action == "r"
      raze(@other_player)
    elsif action == "c"
      call(@other_player)
    elsif action == "a"
      all_in(@other_player)
    end
  end
  
  def end_hand
    @other_player, @button_player = @button_player, @other_player
    @community_cards = []
    @other_player.pocket = []
    @button_player.pocket = []
    @current_hand = false
  end
  
  def determine_winner
    op_best_hand = best_hand(all_hands_from_cards(@community_cards + @other_player.pocket))
    bp_best_hand = best_hand(all_hands_from_cards(@community_cards + @button_player.pocket))
    da_bestest = best_hand([op_best_hand, bp_best_hand])
    if da_bestest == op_best_hand
      @other_player.chips += @pot
      puts "#{@other_player.name} wins the pot with a #{winning_hand(op_best_hand)}"
      new_hand()
    elsif da_bestest == bp_best_hand
      @button_player += @pot
      puts "#{@button_player.name} wins the pot with a #{winning_hand(bp_best_hand)}"
      new_hand()
    else
      puts "Split pot!"
      @button_player.chips += @pot / 2
      @other_player.chips += @pot / 2
      new_hand()
    end
  end
  
  def game_over?
    if @button_player.chips < 10
      puts "Game over! #{@other_player.name}, you win!"
    elsif @other_player.chips < 10
      puts "Game over! #{@button_player.name}, you win!"
    end
  end
  
  def fold(player)
    if player == @other_player
      @button_player.chips += @pot
      end_hand()
    elsif player == @button_player
      @other_player.chips += @pot
      end_hand()
    end
  end
  
  def all_in(player)
    if player == @other_player
      if @button_player.chips + @bp_bet <= @other_player.chips + @op_bet
        @pot += @button_player.chips
        @op_bet = @button_player.chips + @bp_bet
        @other_player.chips -= @button_player.chips
        puts "#{@button_player.name}, #{@other_player.name} went all-in. Do you wish to call? Type y or n"
        answer = gets.chomp
        if answer == "y"
          call(@button_player)
        elsif answer == "n"
          fold(@button_player)
        end
      else
        @pot += @other_player.chips
        @op_bet = @other_player.chips + @op_bet
        @other_player.chips = 0
        puts "#{@button_player.name}, #{@other_player.name} went all-in. Do you wish to call? Type y or n"
        answer = gets.chomp
        if answer == "y"
          call(@button_player)
        elsif answer == "n"
          fold(@button_player)
        end        
      end
    elsif player == @button_player
      if @other_player.chips + @op_bet <= @button_player.chips + @bp_bet
        @pot += @other_player.chips
        @bp_bet = @other_player.chips + @op_bet
        @button_player.chips -= @other_player.chips
        puts "#{@other_player.name}, #{@button_player.name} went all-in. Do you wish to call? Type y or n"
        answer = gets.chomp
        if answer == "y"
          call(@other_player)
        elsif answer == "n"
          fold(@other_player)
        end
      else
        @pot += @button_player.chips
        @bp_bet = @button_player.chips + @bp_bet
        @button_player.chips = 0
        puts "#{@other_player.name}, #{@button_player.name} went all-in. Do you wish to call? Type y or n"
        answer = gets.chomp
        if answer == "y"
          call(@other_player)
        elsif answer == "n"
          fold(@other_player)
        end
      end
    end
  end
  
  def call(player)
    if player == @other_player
      if @other_player.chips > (@bp_bet - @op_bet)
        @pot += (@bp_bet - @op_bet)
        @other_player.chips -= (@bp_bet - @op_bet)
        @op_bet = 0
        @bp_bet = 0
        #The second statement after && is to make sure the flop doesn't initiate before the button player has a chance to act
        if @community_cards.length < 5 && @community_cards.length > 0
          community_deal()
        elsif @community_cards.length == 5
          determine_winner()
        end
      else 
        @pot += (@bp_bet - @op_bet)
        @other_player.chips = 0
        see_river()
        determine_winner()
      end
    elsif player == @button_player
      if @button_player.chips > (@op_bet - @bp_bet)
        @pot += (@op_bet - @bp_bet)
        @button_player.chips -= (@op_bet - @bp_bet)
        @op_bet = 0
        @bp_bet = 0
        if @community_cards.length < 5
          community_deal()
        else
          determine_winner()
        end
      else 
        @pot += (@op_bet - @bp_bet)
        @button_player.chips = 0
        see_river()
        determine_winner()
      end
    end
  end
  
  def bet(player)
    if player == @other_player
      bet_loop = true
      while bet_loop = true
        puts puts "#{@other_player.name}, the pot is #{@pot}. How much would you like to bet?"
        bet_amount = gets.chomp.to_i
        if bet_amount > @button_player.chips
          @pot += @button_player.chips
          @other_player.chips -= @button_player.chips
          @op_bet = @button_player.chips
          bet_loop = false
        elsif bet_amount < 10
          puts "That's less than a min bet. Please enter at least 10"
          redo
        elsif bet_amount >= @other_player.chips
          puts "You cannot bet more than your own chip count. Please try again. (If you want to go all-in, type 'a')"
          redo
        else
          pot_before = @pot
          @op_bet = bet_amount
          @pot += @op_bet
          @other_player.chips -= @op_bet
          bet_loop = false
          puts "#{@other_player.name} has bet #{@op_bet} into a #{pot_before} chip pot. The pot is now #{@pot}. Your pocket cards are #{@button_player.pocket}. #{@op_bet - @bp_bet} chips to call. Type f, c, r, or a"
          action = gets.chomp
          if action == "r"
            raze(@button_player)
          elsif action == "f"
            fold(@button_player)
          elsif action == "c"
            call(@button_player)
          elsif action == "a"
            all_in(@button_player)
          end
        end
      end
    elsif player == @button_player
      bet_loop = true
      while bet_loop = true
        puts "#{@button_player.name}, the pot is #{@pot}. How much would you like to bet?"
        bet_amount = gets.chomp.to_i
        if bet_amount > @other_player.chips
          @pot += @other_player.chips
          @button_player.chips -= @other_player.chips
          @bp_bet = @other_player.chips
          bet_loop = false
        elsif bet_amount < 10
          puts "That's less than a min bet. Please enter at least 10"
          redo
        elsif bet_amount >= @button_player.chips
          puts "You cannot bet more than your own chip count. Please try again. (If you want to go all-in, type 'a')"
          redo
        else
          pot_before = @pot
          @bp_bet = bet_amount
          @pot += @bp_bet
          @button_player.chips -= @bp_bet
          bet_loop = false
          puts "#{@button_player.name} has bet #{@bp_bet} into a #{pot_before} chip pot. The pot is now #{@pot}. Your pocket cards are #{@other_player.pocket}. #{@bp_bet - @op_bet} chips to call. Type f, c, r, or a"
          action = gets.chomp
          if action == "r"
            raze(@other_player)
          elsif action == "f"
            fold(@other_player)
          elsif action == "c"
            call(@other_player)
          elsif action == "a"
            all_in(@other_player)
          end
        end
      end
    end
  end
      
  def raze(player)
    if player == @other_player
      raze_loop = true
      while raze_loop = true
        puts "You want to raise the current bet of #{@bp_bet}. How much do you want to raise your bet to?"
        raise_amount = gets.chomp.to_i
        if raise_amount > @button_player.chips + @bp_bet
          @pot += (@button_player.chips + (@bp_bet - @op_bet))
          @other_player.chips -= @button_player.chips + (@bp_bet - @op_bet)
          @op_bet = @button_player.chips + @bp_bet
          raze_loop = false
          puts "#{@button_player.name}, #{@other_player.name} has raised you all-in. Do you wish to call? Type y or n"
          answer = gets.chomp
          if answer == "y"
            call(@button_player)
          elsif answer == "n"
            fold(@button_player)
          end
        elsif raise_amount < 20
          puts "That's less than a min raise. Please enter at least 20"
          redo
        elsif raise_amount >= @other_player.chips
          puts "You cannot raise beyond your own chip count. Please try again. (If you want to go all-in, type 'a')"
          redo
        elsif raise_amount < @bp_bet
          puts "That's not a raise. It's #{@bp_bet - @op_bet} chips to call. Try again."
          redo
        else
          @pot += raise_amount - @op_bet
          @other_player.chips -= (raise_amount - @op_bet)
          @op_bet = raise_amount
          puts "Test, woohoo we made it to this conditional branch"
          raze_loop = false
          puts "#{@other_player.name} has raised the bet to #{@op_bet}. The pot is now #{@pot}. Your pocket cards are #{@button_player.pocket}. #{@op_bet - @bp_bet} chips to call. Type f, c, r, or a"
          action = gets.chomp
          if action == "r"
            raze(@button_player)
          elsif action == "f"
            fold(@button_player)
          elsif action == "c"
            call(@button_player)
          elsif action == "a"
            all_in(@button_player)
          end
        end
      end

    elsif player == @button_player
      raze_loop = true
      while raze_loop = true
        puts "You want to raise the current bet of #{@op_bet}. How much do you want to raise your bet to?"
        raise_amount = gets.chomp.to_i
        if raise_amount > @other_player.chips + @op_bet
          @pot += (@other_player.chips + (@op_bet - @bp_bet))
          @button_player.chips -= @other_player.chips + (@op_bet - @bp_bet)
          @bp_bet = @other_player.chips + @op_bet
          raze_loop = false
          puts "#{@other_player.name}, #{@button_player.name} has raised you all-in. Do you wish to call? Type y or n"
          answer = gets.chomp
          if answer == "y"
            call(@other_player)
          elsif answer == "n"
            fold(@other_player)
          end
        elsif raise_amount < 20
          puts "That's less than a min raise. Please enter at least 20"
          redo
        elsif raise_amount >= @button_player.chips
          puts "You cannot raise beyond your own chip count. Please try again. (If you want to go all-in, type 'a')"
          redo
        elsif raise_amount < @op_bet
          puts "That's not a raise. It's #{@op_bet - @bp_bet} chips to call. Try again."
          redo
        else
          @pot += raise_amount - @bp_bet
          @button_player.chips -= (raise_amount - @bp_bet)
          @bp_bet = raise_amount
          raze_loop = false
          puts "Test, woohoo we made it to this conditional branch"
          puts "#{@button_player.name} has raised the bet to #{@bp_bet}. The pot is now #{@pot}. Your pocket cards are #{@other_player.pocket}. #{@bp_bet - @op_bet} chips to call. Type f, c, r, or a"
          action = gets.chomp
          if action == "r"
            raze(@other_player)
          elsif action == "f"
            fold(@other_player)
          elsif action == "c"
            call(@other_player)
          elsif action == "a"
            all_in(@other_player)
          end
        end
      end
    end
  end
      
  def game_logic
    get_player_names()
    @current_hand = true
    
    while @current_hand
      begin_hand()
    end  
  end
end

Game.new.game_logic