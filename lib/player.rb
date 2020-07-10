
class Player

  attr_reader :color, :human
  
  def initialize(color = 'W', human = true)
    @color = color
    @human = human
  end
end