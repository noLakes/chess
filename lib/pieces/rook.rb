
class Rook

  attr_reader :color, :pos, :txt, :increments

  def initialize(color = 'W', pos = nil)
    @color = color
    @pos = pos
    @txt = @color == 'W' ? "\u2656" : "\u265C"
    @increments = []
  end

end
