require '/Users/Shan/web-projects/odin_on_rails/ruby_projects/chess/lib/chess_methods.rb'

class Pawn
  include Chess_methods

  attr_reader :color, :pos, :txt, :moved, :last_move, :increments, :range, :in_range

  def initialize(color = 'W', pos = nil)
    @color = color
    @pos = pos
    @txt = @color == 'W' ? "\u2659" : "\u265F"
    @moved = false
    @last_move = nil
    @increments = { 'W' => [[0, 1], [0, 2], [-1, 1], [1, 1]],
      'B' => [[0, -1], [0, -2], [-1, -1], [1, -1]] }.freeze
    @range = { 'W' => [[0, 1], [0, 2], [-1, 1], [1, 1]],
      'B' => [[0, -1], [0, -2], [-1, -1], [1, -1]] }.freeze
    @in_range = @pos.nil? ? [] : get_in_range(@pos, @range[@color])
  end

  def pos=(new_pos)
    return nil unless in_board(new_pos)
    @pos = new_pos
    @in_range = get_in_range(@pos, @range[@color])
  end

  def moved_true
    @moved = true
  end

  def last_move=(inc)
    @last_move = inc
  end

end