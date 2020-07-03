require 'board.rb'
require 'pieces.rb'

class Cell
  attr_reader :pos, :piece, :adjacent

  def initialize(pos, piece = nil, adj = [])
    @pos = pos
    @piece = piece
    @adjacent = adj
  end

  def txt
    piece.nil? ? '[ ]' : piece.txt
  end

  def add_adjacents(*cells)
    cells.each do |cell|
      if cell.pos[0].between?('a', 'g') && cell.pos[1].between?(1, 8)
        @adjacent << cell
      end
    end
  end
end