
class Piece

  attr_reader :color, :pos, :txt, :increments

  def initialize(color = 'W', pos = nil)
    @color = color
    @pos = pos
    @txt = @color == 'W' ? "W" : "B"
    @increments = []
  end

end