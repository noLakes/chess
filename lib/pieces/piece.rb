
class Piece

  attr_reader :color, :pos, :txt

  def initialize(color = 'W', pos = nil)
    @color = color
    @pos = pos
    @txt = @color == 'W' ? "W" : "B"
  end

end