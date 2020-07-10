require_relative 'cell'
require_relative 'board'
require_relative 'chess_methods'
Dir["/pieces/*"].each {|file| require file }

class Game
  include Chess_methods
  attr_reader :board, :player, :turn

  def initialize
    @board = Board.new
    @player = { 1 => Player.new, 2 => Player.new('B', false)}
    @turn = @player[1]
  end

  def get_move
    puts "enter your move (eg: a4 a7)"
    move = gets.chomp.to_s
    move
  end

  def format_input(input)
    input = input.split
    input.map! do |pos|
      pos = pos.split(//)
      pos[1] = pos[1].to_i
      pos
    end
  end

end