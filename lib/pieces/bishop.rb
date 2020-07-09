require '/Users/Shan/web-projects/odin_on_rails/ruby_projects/chess/lib/chess_methods.rb'

class Bishop
  include Chess_methods

  attr_reader :color, :pos, :txt, :increments, :range, :in_range

  def initialize(color = 'W', pos = nil)
    @color = color
    @pos = pos
    @txt = @color == 'W' ? "\u2657" : "\u265D"
    @increments = [ [1, 1], [1, -1], [-1, -1], [-1, 1] ].freeze
    @range = [ [1, 1], [2, 2], [3, 3], [4, 4], [5, 5], [6, 6], [7, 7],
    [1, -1], [2, -2], [3, -3], [4, -4], [5, -5], [6, -6], [7, -7],
    [-1, -1], [-2, -2], [-3, -3], [-4, -4], [-5, -5], [-6, -6], [-7, -7], 
    [-1, 1], [-2, 2], [-3, 3], [-4, 4], [-5, 5], [-6, 6], [-7, 7] ].freeze
    @in_range = []
  end

  def pos=(new_pos)
    return nil unless in_board(new_pos)
    @pos = new_pos
    @in_range = get_in_range(@pos, @range)
  end

end
