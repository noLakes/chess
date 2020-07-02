require 'board.rb'
require 'pieces.rb'

class Cell
  attr_reader :pos, :piece, :adjacent

  def initialize(pos, piece = nil, adj = [])
    @pos = pos
    @piece = piece
    @adjacent = adj
  end
end