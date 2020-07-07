require_relative 'cell'
require_relative 'board'
Dir["/pieces/*"].each {|file| require file }

class Game
  

  attr_reader :board, :player, :turn

  def initialize
    @board = Board.new
    @player = ['W', 'B']
    @turn = @player[0]
  end

end