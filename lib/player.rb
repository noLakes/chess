
class Player

  attr_reader :color, :human, :score
  
  def initialize(color = 'W', human = true)
    @color = color
    @human = human
    @score = 0
  end

  def add_win
    @score += 1
  end

  def txt
    @color == 'W' ? 'white' : 'black'
  end
end