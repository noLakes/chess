require_relative 'cell'
require_relative 'board'
require_relative 'chess_methods'
Dir["/pieces/*"].each {|file| require file }

class Game
  include Chess_methods
  attr_reader :board, :player, :turn

  def initialize
    @board = Board.new
    @player = ['W', 'B']
    @turn = @player[0]
  end

end