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
    move = nil
    loop do
      puts "enter your move (eg: a4 a7)"
      move = format_input(gets.chomp.to_s)
      break if validate(move)
    end
    move
  end

  def validate(move)
    return false unless valid_input(move)
    return false unless valid_range(move)
    return false unless valid_path(move)
    return true
  end

  #converts input to array of cells
  def format_input(input)
    result = []
    input = input.split
    input.map! do |pos|
      pos = pos.split(//)
      pos[1] = pos[1].to_i
      pos
    end
    input.each { |pos| result << @board.cells[pos]}
    result
  end

  #designed to take formatted input
  def valid_input(cells)
    if cells[0].nil? || cells[1].nil?
      puts "error: enter valid positions"
      return false
    elsif cells[0].piece.nil?
      puts "error: starting position has no piece!"
      return false
    elsif cells[0].piece.color != @turn.color
      puts "error: select friendly piece to move"
      return false
    elsif cells[1].piece != nil && cells[1].piece.color == @turn.color
      puts "error: friendly piece at destination"
      return false
    else
      return true
    end
  end

  #designed to take formatted input
  def valid_range(cells)
    return false if cells[0].nil? || cells[1].nil?
    cells[0].piece.in_range.include?(cells[1].pos)
  end

  #designed to take formatted input
  def pos_difference(cells)
    x_diff = cells[1].pos[0].ord - cells[0].pos[0].ord
    y_diff = cells[1].pos[1] - cells[0].pos[1]
    [x_diff, y_diff]
  end

  #reduces x > 0 to 1 and x < 0 to -1
  def diff_to_inc(diff)
    result = []
    diff.each do |num|
      if num > 0
        result << 1
      elsif num < 0
        result << -1
      else
        result << 0
      end
    end
    result
  end

  #designed to take formatted input
  def valid_path(cells)
    piece = cells[0].piece
    diff = pos_difference(cells)
    
    inc = piece.increments.include?(diff) ? diff : diff_to_inc(diff)
    result = false
    read = @board.cells[alpha_add(cells[0].pos, inc)]
    loop do
      if read == cells[1]
        result = true
        break
      elsif read.piece != nil
        break
      end
      read = @board.cells[alpha_add(read.pos, inc)]
    end
    result
  end

  #designed to take formatted input (assumes move is valid)
  def move(cells)
    cells[1].piece = cells[0].piece
    cells[0].piece = nil
  end

end