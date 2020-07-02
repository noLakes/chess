require 'board.rb'
require 'pieces.rb'

class Cell
  attr_reader :piece, :adjacent

  def initialize(piece = nil, adj = [])
    @piece = piece
    @adjacent = adj
  end
end