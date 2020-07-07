
class King
  include Piece

  attr_reader :color, :pos, :txt, :increments

  def initialize(color = 'W', pos = nil)
    @color = color
    @pos = pos
    @txt = @color == 'W' ? "\u2654" : "\u265A"
    @increments = [ [0, 1], [1, 1], [1, 0], [1, -1],
    [0, -1], [-1, -1], [-1, 0], [-1, 1] ]
  end

end

