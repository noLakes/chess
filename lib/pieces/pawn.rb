
class Pawn

  attr_reader :color, :pos, :txt, :increments

  def initialize(color = 'W', pos = nil)
    @color = color
    @pos = pos
    @txt = @color == 'W' ? "\u2659" : "\u265F"
    @increments = [[0, 1], [0, 2], [-1, 1], [1, 1]]
  end

end