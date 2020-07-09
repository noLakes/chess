require '/Users/Shan/web-projects/odin_on_rails/ruby_projects/chess/lib/chess_methods.rb'

class Queen
  include Chess_methods

  attr_reader :color, :pos, :txt, :increments, :range, :in_range

  def initialize(color = 'W', pos = nil)
    @color = color
    @pos = pos
    @txt = @color == 'W' ? "\u2655" : "\u265B"
    @increments = [ [1, 1], [1, -1], [-1, -1], [-1, 1],
    [0, 1], [1, 0], [0, -1], [-1, 0] ].freeze
    @range = [[1, 1], [2, 2], [3, 3], [4, 4], [5, 5], [6, 6], [7, 7],
    [1, -1], [2, -2], [3, -3], [4, -4], [5, -5], [6, -6], [7, -7],
    [-1, -1], [-2, -2], [-3, -3], [-4, -4], [-5, -5], [-6, -6], [-7, -7], 
    [-1, 1], [-2, 2], [-3, 3], [-4, 4], [-5, 5], [-6, 6], [-7, 7],
    [0, 1], [0, 2], [0, 3], [0, 4], [0, 5], [0, 6], [0, 7], 
    [1, 0], [2, 0], [3, 0], [4, 0], [5, 0], [6, 0], [7, 0],
    [0, -1], [0, -2], [0, -3], [0, -4], [0, -5], [0, -6], [0, -7],
    [-1, 0], [-2, 0], [-3, 0], [-4, 0], [-5, 0], [-6, 0], [-7, 0]].freeze
    @in_range = []
  end

  def pos=(new_pos)
    return nil unless in_board(new_pos)
    @pos = new_pos
    @in_range = get_in_range(@pos, @range)
  end

end