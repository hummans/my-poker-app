class Game
    
  attr_accessor :game_deck, :pot, :players, :button_player, :other_player, :community_cards, :player1, :player2
  
  def initialize
      @game_deck = Deck.new
      @pot = 0
      @player1 = Player.new
      @player2 = Player.new
      @players = [@player1, @player2].shuffle
      @button_player = @players[0]
      @other_player = @players[1]
      @community_cards = []
  end
  
  def deal
     @button_player.pocket = @game_deck.shuffled.slice!(0,2)
     @other_player.pocket = @game_deck.shuffled.slice!(0,2)
  end
  
  def game_logic
    puts "What is player 1's name?"
    @player1.name = gets.chomp
    puts "What is player 2's name?"
    @player2.name = gets.chomp
    playgame = true
    while playgame
      deal
      @button_player.chips -= 10
      @other_player.chips -= 5
      @pot = 15
      puts "#{@other_player.name}, you are out of position. The pot is #{@pot}. Your pocket cards are #{@other_player.pocket}. Type f, c, r, or a"
      action = gets.chomp
      if action == "f"
        @button_player.chips += @pot
        @button_player, @other_player = @other_player, @button_player
        redo
      elsif action == "r"
        raise_query = true
        while raise_query
          puts "You have 5 chips invested in the pot. Min raise is to 20. How much do you want to raise your bet to?"
          raise_amount = gets.chomp.to_i
          if raise_amount < 20
            puts "That's less than a min raise. Please enter at least 20"
            redo
          elsif raise_amount >= @other_player.chips
            puts "You cannot raise beyond your own chip count. If you want to go all-in, type a. Please try again"
            redo
          elsif raise_amount >= 20 && raise_amount < @other_player.chips
            @pot += (raise_amount - 5)
            @other_player.chips -= (raise_amount - 5)
            puts "#{@button_player.name}, the pot has been raised. #{@pot - 20} chips to call. Type f, c, r, or a"
            action = gets.chomp
            if action == "r"
              redo
            else break          
            end
          end
        end  
      else break
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