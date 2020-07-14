require '/Users/Shan/web-projects/odin_on_rails/ruby_projects/chess/lib/chess_methods.rb'

class Rook
  include Chess_methods

  attr_reader :color, :pos, :moved, :txt, :increments, :range, :in_range

  def initialize(color = 'W', pos = nil)
    @color = color
    @pos = pos
    @moved = false
    @txt = @color == 'W' ? "\u2656" : "\u265C"
    @increments = [ [0, 1], [1, 0], [0, -1], [-1, 0] ].freeze
    @range = [ [0, 1], [0, 2], [0, 3], [0, 4], [0, 5], [0, 6], [0, 7], 
    [1, 0], [2, 0], [3, 0], [4, 0], [5, 0], [6, 0], [7, 0],
    [0, -1], [0, -2], [0, -3], [0, -4], [0, -5], [0, -6], [0, -7],
    [-1, 0], [-2, 0], [-3, 0], [-4, 0], [-5, 0], [-6, 0], [-7, 0] ].freeze
    @in_range = @pos.nil? ? [] : get_in_range(@pos, @range)
  end

  def pos=(new_pos)
    return nil unless in_board(new_pos)
    @pos = new_pos
    @in_range = get_in_range(@pos, @range)
  end

  def moved_true
    @moved = true
  end

end
