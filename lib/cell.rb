require 'board.rb'
require 'pieces.rb'

class Cell
  attr_reader :val, :adjacent

  def initialize(val = nil, adj = [])
    @val = val
    @adjacent = adj
  end
end