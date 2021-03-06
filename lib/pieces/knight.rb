require '/Users/Shan/web-projects/odin_on_rails/ruby_projects/chess/lib/chess_methods.rb'

class Knight
  include Chess_methods

  attr_reader :color, :pos, :txt, :increments, :range, :in_range

  def initialize(color = 'W', pos = nil)
    @color = color
    @pos = pos
    @txt = @color == 'W' ? "\u2658" : "\u265E"
    @increments = [ [1, 2], [2, 1], [2, -1], [1, -2],
    [-1, -2], [-2, -1], [-2, 1], [-1, 2] ].freeze
    @range = [ [1, 2], [2, 1], [2, -1], [1, -2],
    [-1, -2], [-2, -1], [-2, 1], [-1, 2] ].freeze
    @in_range = @pos.nil? ? [] : get_in_range(@pos, @range)
  end

  def pos=(new_pos)
    return nil unless in_board(new_pos)
    @pos = new_pos
    @in_range = get_in_range(@pos, @range)
  end

end
