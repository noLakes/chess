require_relative 'cell'
require_relative 'board'
require_relative 'chess_methods'
require_relative 'player'
require 'pry'


Dir["/pieces/*"].each {|file| require file }

class Game
  include Chess_methods
  attr_reader :board, :player
  attr_accessor :turn

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

  #big logic gate to validate all types of move
  def validate_move(move, testing = false)
    return false unless valid_input(move, testing)
    return false unless valid_range(move, testing)
    
    if moving_pawn(move)
      if try_double_step(move)
        return false unless valid_double_step(move)
      end
      if try_diagonal(move)
        return false unless diagonal_capture(move) || en_passant(move)
      end
    end

    if try_castling(move)
      return false unless valid_castling(move)
    end

    return false unless valid_path(move, testing)
    return true
  end

  #converts input to array of cells
  def format_input(input, board = @board)
    result = []
    input = input.split
    input.map! do |pos|
      pos = pos.split(//)
      pos[1] = pos[1].to_i
      pos
    end
    input.each { |pos| result << board.cells[pos]}
    result
  end

  #designed to take formatted input
  def valid_input(cells, testing = false)
    if cells[0].nil? || cells[1].nil?
      puts "error: enter valid positions" if !testing
      return false
    elsif cells[0].piece.nil?
      puts "error: starting position has no piece!" if !testing
      return false
    elsif cells[0].piece.color != @turn.color
      puts "error: select friendly piece to move" if !testing
      return false
    elsif cells[1].piece != nil && cells[1].piece.color == @turn.color
      puts "error: friendly piece at destination" if !testing
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
  def valid_path(cells, testing = false, board = @board)
    piece = cells[0].piece
    diff = pos_difference(cells)
    
    inc = piece.increments.include?(diff) ? diff : diff_to_inc(diff)
    result = false
    read = board.cells[alpha_add(cells[0].pos, inc)]
    loop do
      if read == cells[1]
        result = true
        break
      elsif read.piece != nil
        break
      end
      read = board.cells[alpha_add(read.pos, inc)]
    end
    if result == false
      puts "no path for #{cells[0].piece.class} #{cells[0].pos} ==> #{cells[1].pos}" if !testing
    end
    result
  end

  #designed to take formatted input (assumes move is valid)
  def move(cells)
    
    if moving_pawn(cells) && en_passant(cells)
      perform_en_passant(cells)
    end

    if try_castling(cells) && valid_castling(cells)
      perform_castling(cells[1])
    end

    cells[1].piece = cells[0].piece
    cells[1].piece.pos = cells[1].pos
    cells[0].piece = nil

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
  def threat(threat_cell, color = @turn.color, board = @board)
    threat = false
    board.cells.each_pair do |pos, cell|
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
  def valid_castling(cells, testing = false, board = @board)
    diff = pos_difference(cells)
    return false if diff[1] != 0

    rook = nil
    king = cells[0].piece
    return false if king.moved

    if king.color == 'W'
      rook = diff[0] == 2 ? board['h', 1].piece : board['a', 1].piece
    elsif king.color == 'B'
      rook = diff[0] == 2 ? board['h', 8].piece : board['a', 8].piece
    end

    
    return false if rook.class != Rook
    return false if rook.moved

    path = [cells[0], board.cells[rook.pos]]
    inc = diff_to_inc(diff)
    
    read = path[0]
    i = 1
    loop do
      read = board.cells[alpha_add(read.pos, inc)]
      break if read == path[1]
      return false if !read.piece.nil?
      return false if i < 3 && threat(read, king.color)
      i += 1 
    end
    true
  end

  def perform_castling(king_cell, board = @board)
    case king_cell.pos
    when ['g', 1]
      move([board['h', 1], board['f', 1]])
    when ['c', 1]
      move([board['a', 1], board['d', 1]])
    when ['g', 8]
      move([board['h', 8], board['f', 8]])
    when ['c', 8]
      move([board['a', 8], board['d', 8]])
    end
  end

  def moving_pawn(cells)
    cells[0].piece.class == Pawn
  end

  #checks if you are trying to double step
  def try_double_step(cells) 
    diff = pos_difference(cells)
    [[0, 2], [0, -2]].include?(diff)
  end

  #checks if your double step attempt is valid
  def valid_double_step(cells)
    cells[0].piece.moved == false
  end

  #checks if you are trying to move a pawn diagonally
  def try_diagonal(cells)
    diff = pos_difference(cells)
    [[1, 1], [-1, 1], [-1, -1], [1, -1]].include?(diff)
  end

  #checks if you are trying a diagonal capture
  def diagonal_capture(cells)
    !cells[1].piece.nil? && cells[0].piece.color != cells[1].piece.color
  end

  #checks if you are trying en_passant
  def en_passant(cells, board = @board)
    if cells[0].piece.color == 'W'
      target = board.cells[alpha_add(cells[1].pos, [0, -1])].piece
      return false unless target.class == Pawn && target.color == 'B' && target.last_move == [0, -2]
    elsif cells[0].piece.color == 'B'
      target = board.cells[alpha_add(cells[1].pos, [0, 1])].piece
      return false unless target.class == Pawn && target.color == 'W' && target.last_move == [0, 2]
    end
    true
  end

  def perform_en_passant(cells, board = @board)
    color = cells[0].piece.color
    if color == 'W'
      board.cells[alpha_add(cells[1].pos, [0, -1])].piece = nil
    elsif color == 'B'
      target = board.cells[alpha_add(cells[1].pos, [0, 1])].piece = nil
    end
  end

  def get_king(color, board = @board)
    king = nil
    board.cells.each_value do |cell|
      if !cell.piece.nil? && cell.piece.color == color && cell.piece.class == King
        king = cell.piece
        break
      end
    end
    king
  end

  def check(color, board = @board)
    threat(board.cells[get_king(color).pos], color)
  end

  #returns array of formatted valid moves for given color
  def valid_moves(color, board = @board)
    moves = []
    board.cells.each_value do |cell|
      if !cell.piece.nil? && cell.piece.color == color
        cell.piece.in_range.each do |pos2|
          move = [cell, board.cells[pos2]]
          moves << move if validate_move(move, true)
        end
      end
    end
    moves.length == 0 ? nil : moves
  end

  def check_promotion(cells)
    pawn = cells[0].piece
    return false if pawn.class != Pawn
    if pawn.color == 'W' && cells[1].pos[1] == 8
      true
    elsif pawn.color == 'B' && cells[1].pos[1] == 1
      true
    else
      false
    end
  end

  def promote(cell)
    return nil if cell.piece.class != Pawn
    types = { 'queen' => Queen, 'king' => King, 'knight' => Knight,
      'rook' => Rook, 'bishop' => Bishop }
    input = nil
    puts "enter type of piece for promotion:"
    loop do
      input = gets.chomp.downcase
      if !types.include?(input)
        puts "#{input} is invalid! please enter a valid piece:"
        next
      end
      cell.piece = types[input].new(cell.piece.color, cell.pos)
      break
    end
  end

  

end