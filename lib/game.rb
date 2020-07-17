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
      break if validate_move(move)
    end
    move
  end

  def validate_move(move)
    return false unless valid_input(move)
    return false unless valid_range(move)
    
    if try_castling(move)
      return false unless valid_castling(move)
    else
      return false unless valid_path(move)
    end
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
  def valid_input(cells, testing = false)
    if cells[0].nil? || cells[1].nil?
      puts "error: enter valid positions" if !testing
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
  def valid_range(cells, testing = false)
    if cells[0].nil? || cells[1].nil?
      puts "error: enter valid positions" if !testing
      return false
    end
    if cells[0].piece.in_range.include?(cells[1].pos)
      return true
    else
      puts "#{cells[1].pos} not in-range for #{cells[0].piece.class} @ #{cells[0].pos}" if !testing
      return false
    end
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
  def valid_path(cells, testing = false)
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
    if result == false
      puts "no path for #{cells[0].piece.class} #{cells[0].pos} ==> #{cells[1].pos}" if !testing
    end
    result
  end

  #designed to take formatted input (assumes move is valid)
  def move(cells)
    cells[1].piece = cells[0].piece
    cells[1].piece.pos = cells[1].pos
    cells[0].piece = nil
    perform_castling(cells[1]) if try_castling(cells)
    update_moved(cells[1].piece, cells)
  end

  def update_moved(piece, cells)
    if [Rook, King, Pawn].include?(piece.class)
      piece.moved_true
      if piece.class == Pawn
        piece.last_move = pos_difference(cells)
      end
    end
  end

  #returns true if cell is under threat
  def threat(threat_cell, color = @turn.color)
    threat = false
    @board.cells.each_pair do |pos, cell|
      if cell.piece != nil && cell.piece.color != color
        range = cell.piece.in_range.include?(threat_cell.pos)
        next unless range
        path = valid_path([cell, threat_cell], true)
        next unless path
        threat = true
        break
      end
    end
    threat
  end

  #checks if you are trying to move a king 2 spaces
  def try_castling(cells, testing = false)
    if cells[0].piece.class != King
      return false
    elsif !pos_difference(cells).include?(2) && !pos_difference(cells).include?(-2)
      return false
    else
      return true
    end
  end

  #checks all clauses for invalid castling
  def valid_castling(cells, testing = false)
    diff = pos_difference(cells)
    return false if diff[1] != 0

    rook = nil
    king = cells[0].piece
    return false if king.moved

    if king.color == 'W'
      rook = diff[0] == 2 ? @board['h', 1].piece : @board['a', 1].piece
    elsif king.color == 'B'
      rook = diff[0] == 2 ? @board['h', 8].piece : @board['a', 8].piece
    end
    
    return false if rook.class != Rook
    return false if rook.moved

    path = [cells[0], @board.cells[rook.pos]]
    inc = diff_to_inc(diff)
    
    read = path[0]
    i = 1
    loop do
      read = @board.cells[alpha_add(read.pos, inc)]
      break if read == path[1]
      return false if !read.piece.nil?
      return false if i < 3 && threat(read)
      i += 1 
    end
    true
  end

  def perform_castling(king_cell)
    case king_cell.pos
    when ['g', 1]
      move([@board['h', 1], @board['f', 1]])
    when ['c', 1]
      move([@board['a', 1], @board['d', 1]])
    when ['g', 8]
      move([@board['h', 8], @board['f', 8]])
    when ['c', 8]
      move([@board['a', 8], @board['d', 8]])
    end
  end

  def moving_pawn(cells)
    cells[0].piece.class == Pawn
  end

  def try_double_step(cells) 
    diff = pos_difference(cells)
    [[0, 2], [0, -2]].include?(diff)
  end

  def valid_double_step(cells)
    cells[0].piece.moved == false
  end

  def try_diagonal(cells)
    diff = pos_difference(cells)
    [[1, 1], [-1, 1], [-1, -1], [1, -1]].include?(diff)
  end

end