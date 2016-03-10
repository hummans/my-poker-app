class Game
    
  attr_accessor :game_deck, :pot, :players, :button_player, :other_player, :community_cards, :player1, :player2, :bp_bet, :op_bet, :bp_investment, :op_investment
  
  def initialize
      @game_deck = []
      @pot = 0
      @player1 = Player.new
      @player2 = Player.new
      @players = [@player1, @player2].shuffle
      @button_player = @players[0]
      @other_player = @players[1]
      @community_cards = []
      @bp_investment = 0
      @op_investment = 0
      @bp_bet = 0
      @op_bet = 0
  end
  
  def deal
     @button_player.pocket = @game_deck.shuffled.slice!(0,2)
     @other_player.pocket = @game_deck.shuffled.slice!(0,2)
  end
  
  def fold(player)
    if player == @other_player
      @button_player.chips += @pot
      @button_player, @other_player = @other_player, @button_player
    elsif player == @button_player
      @other_player.chips += pot
      @button_player, @other_player = @other_player, @button_player
    end
  end
      
      
  
  def raze(player)
    if player == @other_player
      while true
        puts "You want to raise the current bet of #{@bp_bet.zero? ? @bp_investment : @bp_bet }. How much do you want to raise your bet to?"
        raise_amount = gets.chomp.to_i
        if raise_amount < 20
          puts "That's less than a min raise. Please enter at least 20"
          redo
        elsif raise_amount >= @other_player.chips
          puts "You cannot raise beyond your own chip count. Please try again. (If you want to go all-in, type 'a')"
          redo
        elsif raise_amount < (@bp_bet.zero? ? @bp_investment : @bp_bet)
          puts "That's not a raise. It's #{@bp_investment - @op_investment} to call. Try again."
          redo
        else
          @pot += (raise_amount - @op_investment)
          @other_player.chips -= (raise_amount - @op_investment)
          @op_investment += (raise_amount - @op_investment)
          @op_bet = raise_amount
          puts "Test, woohoo we made it to this conditional branch"
          break
        end
      end
      puts "#{@other_player.name} has raised it to #{@op_bet}. The pot is now #{@pot}. Your pocket cards are #{@button_player.pocket}. #{@op_investment - @bp_investment} chips to call. Type f, c, r, or a"
      action = gets.chomp
      if action == "r"
        raze(@button_player)
      elsif action == "f"
        fold(@button_player)
      elsif action == "c"
        
      elsif action == "a"
    elsif player == @button_player
    end
  end
      
  
  def game_logic
    puts "What is player 1's name?"
    @player1.name = gets.chomp
    puts "What is player 2's name?"
    @player2.name = gets.chomp
    playgame = true
    while playgame
      @game_deck = Deck.new
      deal()
      @button_player.chips -= 10
      @other_player.chips -= 5
      @bp_investment = 10
      @op_investment = 5
      @pot = 15
      puts "#{@other_player.name}, you are out of position. You have #{@other_player.chips} chips. The pot is #{@pot}. Your pocket cards are #{@other_player.pocket}. #{@bp_investment - @op_investment} chips to call. Type f, c, r, or a"
      action = gets.chomp
      if action == "f"
        fold(@other_player)
        redo
      elsif action == "r"
        raze(@other_player)
      end
    end  
  end
end

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

game = Game.new

game.game_logic