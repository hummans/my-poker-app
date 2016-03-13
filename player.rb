class Player
  
  attr_accessor :name, :chips, :pocket
  
  def initialize
    @name = ""
    @chips = 1000
    @pocket = []
  end
end