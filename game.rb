class Game

  require_relative "hand_calculator"

  require_relative "player"

  require_relative "deck"

  include HandCalculator
    
  attr_accessor :deck, :pot, :button_player, :other_player, :community_cards, :bp_bet, :op_bet
  
  def initialize
      @deck = []
      @pot = 0
      @button_player = Player.new
      @other_player = Player.new
      @community_cards = []
      @bp_bet = 0
      @op_bet = 0
  end
  
  def begin_game
    if @button_player.name == ""
      puts "."
      sleep(0.35)
      puts "."
      sleep(0.35)
      puts "."
      sleep(0.35)
      puts "Welcome to Sam Hickey's Poker Madness!\n\n"
      sleep(2)
      puts "Let's begin!"
      sleep(1.25)
      puts "\n"
      puts "What is player 1's name?"
      @button_player.name = gets.chomp.capitalize
      sleep(0.15)
      puts "\nAnd, what is player 2's name?"
      @other_player.name = gets.chomp.capitalize
      new_hand_notification()
    end
  end
  
  def community_deal
    @community_cards.length == 0 ? @community_cards = @deck.slice!(0,3) : @community_cards << @deck.shift
    if @community_cards.length == 3
      puts_cards("other")
      puts "#{@other_player.name}, the pot is now #{@pot}. You have #{@other_player.chips} chips left. Type b, c, or a"
      action = gets.chomp
      determine_action(@other_player, action, "check/bet")
    elsif @community_cards.length == 4
      puts_cards("other")
      puts "#{@other_player.name}, the pot is now #{@pot}. You have #{@other_player.chips} chips left. Type b, c, or a"
      action = gets.chomp
      determine_action(@other_player, action, "check/bet")     
    elsif @community_cards.length == 5
      puts_cards("other")
      puts "#{@other_player.name}, the pot is now #{@pot}. You have #{@other_player.chips} chips left. Type b, c, or a"
      action = gets.chomp
      determine_action(@other_player, action, "check/bet")
    end
  end
  
  def determine_action(player, action, type)
    if player == @other_player
      if type == "check/bet"
        if action == "c"
          check(@other_player)
        elsif action == "b"
          bet(@other_player)
        elsif action == "f"
          fold(@other_player)
        elsif action == "a"
          all_in(@other_player)
        end
      elsif type == "call/raise"
        if action == "c"
          call(@other_player)
        elsif action == "r"
          raze(@other_player)
        elsif action == "f"
          fold(@other_player)
        elsif action == "a"
          all_in(@other_player)
        end
      end
    elsif player == @button_player
      if type == "check/bet"
        if action == "c"
          check(@button_player)
        elsif action == "b"
          bet(@button_player)
        elsif action == "f"
          fold(@button_player)
        elsif action == "a"
          all_in(@button_player)
        end
      elsif type == "call/raise"
        if action == "c"
          call(@button_player)
        elsif action == "r"
          raze(@button_player)
        elsif action == "f"
          fold(@button_player)
        elsif action == "a"
          all_in(@button_player)
        end
      end
    end
  end

  def new_hand
    @other_player, @button_player = @button_player, @other_player
    @community_cards = []
    @deck = ("2".."14").flat_map { |rank| ("a".."d").map { |suit| (rank + suit) } }.shuffle
    @button_player.pocket = @deck.slice!(0,2)
    @other_player.pocket = @deck.slice!(0,2)
    @button_player.chips -= 10
    @other_player.chips -= 5
    @bp_bet = 10
    @op_bet = 5
    @pot = 15
    puts "\n\n"
    puts_cards("other")
    puts "#{@other_player.name}, you are out of position and first to act. You have #{@other_player.chips} chips. The pot is #{@pot}. #{@bp_bet - @op_bet} chips to call. Type c, f, r, or a"
    action = gets.chomp
    determine_action(@other_player, action, "call/raise")
  end

  def new_hand_notification
    sleep(0.5)
    puts "\n"
    puts "Dealing new hand..."
    sleep(0.60)
    print "Wait a moment"
    sleep(0.55)
    print "."
    sleep(0.55)
    print "."
    sleep(0.55)
    print "."
    sleep(0.55)
    print "."
    puts "\n"
    new_hand()
  end
  
  def see_river
    if @community_cards.length == 0
      @community_cards << @deck.slice!(0,5)
      @community_cards.flatten!
    elsif @community_cards.length == 3
      @community_cards << @deck.slice!(0,2)
      @community_cards.flatten!
    elsif @community_cards.length == 4
      @community_cards << @deck.slice!(0,1)
      @community_cards.flatten!
    end
  end
    
  def determine_winner
    op_best_hand = best_hand(all_hands_from_cards(@community_cards + @other_player.pocket)).length > 1 ? best_hand(all_hands_from_cards(@community_cards + @other_player.pocket))[0] : best_hand(all_hands_from_cards(@community_cards + @other_player.pocket)).flatten
    bp_best_hand = best_hand(all_hands_from_cards(@community_cards + @button_player.pocket)).length > 1 ? best_hand(all_hands_from_cards(@community_cards + @button_player.pocket))[0] : best_hand(all_hands_from_cards(@community_cards + @button_player.pocket)).flatten
    da_bestest = best_hand([op_best_hand.flatten, bp_best_hand.flatten]).length > 1 ? best_hand([op_best_hand.flatten, bp_best_hand.flatten]) : best_hand([op_best_hand.flatten, bp_best_hand.flatten]).flatten
    puts "The community cards are:\n\n"
    sleep(1)
    puts "Community cards: #{visual(@community_cards)}\n\n\n"
    sleep(2)
    puts "#{@other_player.name}'s pocket cards and best hand are:\n\n"
    sleep(1)
    puts "#{@other_player.name}'s pocket cards: #{visual(@other_player.pocket)}"
    puts "#{@other_player.name}'s best hand: #{winning_hand(op_best_hand)}#{visual(op_best_hand)}\n\n\n"
    sleep(2)
    puts "#{@button_player.name}'s pocket cards and best hand are:\n\n"
    sleep(1)
    puts "#{@button_player.name}'s pocket cards: #{visual(@button_player.pocket)}"
    puts "#{@button_player.name}'s best hand: #{winning_hand(bp_best_hand)}#{visual(bp_best_hand)}\n\n\n"
    sleep(2)
    puts "THE best hand IS:\n\n"
    sleep(1)

    
    if da_bestest == op_best_hand
      @other_player.chips += @pot
      puts "#{visual(da_bestest)} The best hand: #{@other_player.name}'s!\n\n\n"
      puts "#{@other_player.name}'s hand! #{@other_player.name} wins the pot with a #{winning_hand(op_best_hand)}\n\n\n"
      sleep(1.25)
      print "WOOHOO!"
      puts "\n\n\n"
      if game_over?()
        return
      else
        new_hand_notification()
      end
    elsif da_bestest == bp_best_hand
      @button_player.chips += @pot
      puts "#{visual(da_bestest)} The best hand: #{@button_player.name}'s!\n\n\n"
      puts "#{@button_player.name}'s hand! #{@button_player.name} wins the pot with a #{winning_hand(bp_best_hand)}\n\n\n"
      sleep(1.25)
      print "WOOHOO!"
      puts "\n\n\n"
      if game_over?()
        return
      else
        new_hand_notification()
      end
    else
      puts "Split pot!\n\n\n\n"
      @button_player.chips += @pot / 2
      @other_player.chips += @pot / 2
      sleep(1.25)
      puts "Let's divvy that pot up!"
      new_hand_notification()
    end
  end
  
  def determine_winner_notification(type)
    if type == "all-in"
      puts "All-in! To the river! Determining winner..."
      puts "."
      sleep(0.75)
      puts "."
      sleep(0.75)
      puts "."
      sleep(0.75)
      see_river()
      determine_winner()
    elsif type == "check/call"
      puts "Determining winner..."
      puts "."
      sleep(0.75)
      puts "."
      sleep(0.75)
      puts "."
      sleep(0.75)
      determine_winner()
    end
  end
  
  def game_over?
    if @button_player.chips < 10
      puts "Game over! #{@other_player.name}, you win!"
      return true
    elsif @other_player.chips < 10
      puts "Game over! #{@button_player.name}, you win!"
      return true
    end
  end
  
  def puts_cards(player)
    if player == "other"
      puts "\n\n"
      puts "#{visual(@community_cards)} ^^Community cards^^" unless @community_cards.empty?
      puts "#{visual(@other_player.pocket)}^Pocket cards^\n\n"
    elsif player == "button"
      puts "\n\n"
      puts "#{visual(@community_cards)} ^^Community cards^^" unless @community_cards.empty?
      puts "#{visual(@button_player.pocket)}^Pocket cards^\n\n"
    end
  end

  def check(player)
    if player == @other_player
      puts_cards("button")
      puts "#{@button_player.name}, #{@other_player.name} checked. The pot is #{@pot}. You have #{@button_player.chips} chips left. What would you like to do? Type c, b, a"
      action = gets.chomp
      determine_action(@button_player, action, "check/bet")
    elsif player == @button_player
      if @community_cards.length == 5
        determine_winner_notification("check/call")
      else
        community_deal()
      end
    end
  end
  
  def fold(player)
    if player == @other_player
      @button_player.chips += @pot
      new_hand_notification()
    elsif player == @button_player
      @other_player.chips += @pot
      new_hand_notification()
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
        if @button_player.chips == 0
          determine_winner_notification("all-in")
        elsif @community_cards.length < 5 && (@community_cards.length > 0 || @pot > 20)
          community_deal()
        elsif @pot == 20
          @op_bet = 10
          @bp_bet = 10
          puts_cards("button")
          puts "#{@button_player.name}, #{@other_player.name} limped in. You are on the button. What would you like to do? Type c, r, a"
          action = gets.chomp
          determine_action(@button_player, action, "call/raise")
        else
          determine_winner_notification("check/call")
        end
      else
        @pot += (@bp_bet - @op_bet)
        @other_player.chips = 0
        determine_winner_notification("all-in")
      end
    elsif player == @button_player
      if @button_player.chips > (@op_bet - @bp_bet)
        @pot += (@op_bet - @bp_bet)
        @button_player.chips -= (@op_bet - @bp_bet)
        @op_bet = 0
        @bp_bet = 0
        if @other_player.chips == 0
          determine_winner_notification("all-in")
        elsif @community_cards.length < 5
          community_deal()
        else
          determine_winner_notification("check/call")
        end
      else
        @pot += (@op_bet - @bp_bet)
        @button_player.chips = 0
        determine_winner_notification("all-in")
      end
    end
  end
  
  def bet(player)
    if player == @other_player
      bet_loop = true
      while bet_loop == true
        puts "#{@other_player.name}, the pot is #{@pot}. How much would you like to bet?"
        bet_amount = gets.chomp.to_i
        if bet_amount > @button_player.chips
          @pot += @button_player.chips
          @other_player.chips -= @button_player.chips
          @op_bet = @button_player.chips
          bet_loop = false
          puts_cards("button")
          puts "#{@button_player.name}, #{@other_player.name} has put you all-in. Would you like to call? Type y or n"
          answer = gets.chomp
          if answer == "y"
            call(@button_player)
            bet_loop = false
          elsif answer == "n"
            fold(@button_player)
            bet_loop = false
          end
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
          puts_cards("button")
          puts "#{@button_player.name}, #{@other_player.name} has bet #{@op_bet} into a #{pot_before} chip pot. The pot is now #{@pot}. #{@op_bet - @bp_bet} chips to call. Type f, c, r, or a"
          action = gets.chomp
          determine_action(@button_player, action, "call/raise") 
        end
      end
    elsif player == @button_player
      bet_loop = true
      while bet_loop == true
        puts "#{@button_player.name}, the pot is #{@pot}. How much would you like to bet?"
        bet_amount = gets.chomp.to_i
        if bet_amount > @other_player.chips
          @pot += @other_player.chips
          @button_player.chips -= @other_player.chips
          @bp_bet = @other_player.chips
          bet_loop = false
          puts_cards("other")
          puts "#{@other_player.name}, #{@button_player.name} has put you all-in. Would you like to call?"
          answer = gets.chomp
          if answer == "y"
            call(@other_player)
            bet_loop = false
          elsif answer == "n"
            fold(@other_player)
            bet_loop = false
          end
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
          puts_cards("other")
          puts "#{@other_player.name}, #{@button_player.name} has bet #{@bp_bet} into a #{pot_before} chip pot. The pot is now #{@pot}. #{@bp_bet - @op_bet} chips to call. Type f, c, r, or a"
          action = gets.chomp
          determine_action(@other_player, action, "call/raise")
        end
      end
    end
  end
      
  def raze(player)
    if player == @other_player
      raze_loop = true
      while raze_loop == true
        puts "You want to raise the current bet of #{@bp_bet}. How much do you want to raise your bet to?"
        raise_amount = gets.chomp.to_i
        if raise_amount > @button_player.chips + @bp_bet
          @pot += (@button_player.chips + (@bp_bet - @op_bet))
          @other_player.chips -= @button_player.chips + (@bp_bet - @op_bet)
          @op_bet = @button_player.chips + @bp_bet
          raze_loop = false
          puts_cards("button")
          puts "#{@button_player.name}, #{@other_player.name} has raised you all-in. Do you wish to call? Type y or n"
          answer = gets.chomp
          if answer == "y"
            call(@button_player)
            raze_loop = false
          elsif answer == "n"
            fold(@button_player)
            raze_loop = false
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
          raze_loop = false
          puts_cards("button")
          puts "#{@button_player.name}, #{@other_player.name} has raised the bet to #{@op_bet}. The pot is now #{@pot}. #{@op_bet - @bp_bet} chips to call. Type f, c, r, or a"
          action = gets.chomp
          determine_action(@button_player, action, "call/raise") 
        end
      end

    elsif player == @button_player
      raze_loop = true
      while raze_loop == true
        puts "You want to raise the current bet of #{@op_bet}. How much do you want to raise your bet to?"
        raise_amount = gets.chomp.to_i
        if raise_amount > @other_player.chips + @op_bet
          @pot += (@other_player.chips + (@op_bet - @bp_bet))
          @button_player.chips -= @other_player.chips + (@op_bet - @bp_bet)
          @bp_bet = @other_player.chips + @op_bet
          raze_loop = false
          puts_cards("other")
          puts "#{@other_player.name}, #{@button_player.name} has raised you all-in. Do you wish to call? Type y or n"
          answer = gets.chomp
          if answer == "y"
            call(@other_player)
            raze_loop = false
          elsif answer == "n"
            fold(@other_player)
            raze_loop = false
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
          puts_cards("other")
          puts "#{@other_player.name}, #{@button_player.name} has raised the bet to #{@bp_bet}. The pot is now #{@pot}. #{@bp_bet - @op_bet} chips to call. Type f, c, r, or a"
          action = gets.chomp
          determine_action(@other_player, action, "call/raise") 
        end
      end
    end
  end

  def all_in(player)
    if player == @other_player
      if @button_player.chips + @bp_bet <= @other_player.chips + @op_bet
        other_player_before = @other_player.chips
        @pot += (@button_player.chips + @bp_bet - @op_bet)
        @other_player.chips -= (@button_player.chips + @bp_bet - @op_bet)
        @op_bet = @button_player.chips + (@bp_bet - @op_bet)
        puts_cards("button")
        puts "#{@button_player.name}, #{@other_player.name} went all-in with their #{other_player_before} remaining chips.  You have #{@button_player.chips} left. Calling will put you all in. Do you wish to call? Type y or n"
        answer = gets.chomp
        if answer == "y"
          call(@button_player)
        elsif answer == "n"
          fold(@button_player)
        end
      else
        @pot += @other_player.chips
        @op_bet = @other_player.chips + @op_bet
        puts_cards("button")
        puts "#{@button_player.name}, #{@other_player.name} went all-in with their #{@other_player.chips} remaining chips. #{visual(@button_player.pocket)} You have #{@button_player.chips} left. Do you wish to call? Type y or n"
        @other_player.chips = 0
        answer = gets.chomp
        if answer == "y"
          call(@button_player)
        elsif answer == "n"
          fold(@button_player)
        end        
      end
    elsif player == @button_player
      if @other_player.chips + @op_bet <= @button_player.chips + @bp_bet
        button_player_before = @button_player.chips
        @pot += (@other_player.chips + @op_bet - @bp_bet)
        @button_player.chips -= (@other_player.chips + @op_bet - @bp_bet)
        @bp_bet = (@other_player.chips + @op_bet - @bp_bet)
        puts_cards("other")
        puts "#{@other_player.name}, #{@button_player.name} went all-in with their #{@bp_bet} remaining chips. You have #{@other_player.chips} left. Calling will put you all in. Do you wish to call? Type y or n"
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
        puts_cards("other")
        puts "#{@other_player.name}, #{@button_player.name} went all-in with their #{@bp_bet} remaining chips. #{visual(@other_player.pocket)} You have #{@other_player.chips} left. Do you wish to call? Type y or n"
        answer = gets.chomp
        if answer == "y"
          call(@other_player)
        elsif answer == "n"
          fold(@other_player)
        end
      end
    end
  end
  
  def game_logic
    begin_game()
  end
end

Game.new.game_logic()