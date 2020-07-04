
class Piece
  
  attr_reader :color, :pos, :txt

  def initialize(color = 'W', pos = nil)
    @color = color
    @pos = pos
    @txt = @color == 'W' ? "\u2656" : "\u265C"
  end

end