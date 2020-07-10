require_relative 'cell'
require_relative 'board'
require_relative 'chess_methods'
require_relative 'player'
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
    input
  end

  #designed to take formatted input
  def valid_input(input)
    pos1 = @board.cells[input[0]]
    pos2 = @board.cells[input[1]]
    if pos1.nil? || pos2.nil?
      return false
    elsif pos1.piece.nil?
      return false
    elsif pos1.piece.color != @turn.color
      return false
    elsif pos2.piece != nil && pos2.piece.color == @turn.color
      return false
    else
      return true
    end
  end

  #designed to take formatted input
  def valid_range(input)
    cell1 = @board.cells[input[0]]
    cell2 = @board.cells[input[1]]
    return false if cell1.nil? || cell2.nil?
    cell1.piece.in_range.include?(cell2.pos)
  end

  #designed to take formatted input
  def pos_difference(input)
    x_diff = input[1][0].ord - input[0][0].ord
    y_diff = input[1][1] - input[0][1]
    [x_diff, y_diff]
  end

  #designed to take formatted input (assumes previous tests have passed)
  def valid_path(input)
    
  end

end