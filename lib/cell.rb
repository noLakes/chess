require_relative 'chess_methods'

class Cell
  include Chess_methods
  attr_reader :pos, :piece, :adjacent

  def initialize(pos, piece = nil, adj = [])
    @pos = pos
    @piece = piece
    @adjacent = adj
  end

  def piece=(piece)
    @piece = piece
  end

  def txt
    piece.nil? ? '[ ]' : "[#{piece.txt}]"
  end

  def add_adjacents(*cells)
    cells.each do |cell|
      if in_board(cell.pos)
        @adjacent << cell.pos
      end
    end
  end
end