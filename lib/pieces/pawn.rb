require '/Users/Shan/web-projects/odin_on_rails/ruby_projects/chess/lib/chess_methods.rb'

class Pawn
  include Chess_methods

  attr_reader :color, :pos, :txt, :increments, :range

  def initialize(color = 'W', pos = nil)
    @color = color
    @pos = pos
    @txt = @color == 'W' ? "\u2659" : "\u265F"
    @increments = [[0, 1], [0, 2], [-1, 1], [1, 1]].freeze
    @range = [[0, 1], [0, 2], [-1, 1], [1, 1]].freeze
  end

end