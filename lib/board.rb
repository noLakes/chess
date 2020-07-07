require_relative 'cell'
require_relative 'chess_methods'
Dir["/pieces/*"].each {|file| require file }

VACANT = "[ ]"
INCREMENTS = [[-1, 1], [0, 1], [1, 1], [1, 0], [1, -1], [0, -1], [-1, -1], [-1, 0]]

class Board
  include Chess_methods
  attr_reader :cells

  def initialize
    @cells = build_board
    assign_adjacents
  end

  def build_board
    cells = {}
    files = ['a', 'b', 'c', 'd', 'e', 'f', 'g', 'h']
    ranks = [1, 2, 3, 4, 5, 6, 7, 8]

    files.each do |file|
      ranks.each do |rank|
        cells[[file, rank]] = Cell.new([file, rank])
      end
    end
    cells
  end

  def setup_board
    @cells.each_pair do |key, val|
      if key[1] == 2
        val.piece = Pawn.new('W', key)
      elsif key[1] == 7
        val.piece = Pawn.new('B', key)
      elsif key[1] == 1
        if key[0] == 'a' || key[0] == 'h'
          val.piece = Rook.new('W', key)
        elsif key[0] == 'b' || key[0] == 'g'
          val.piece = Knight.new('W', key)
        elsif key[0] == 'c' || key[0] == 'f'
          val.piece = Bishop.new('W', key)
        elsif key[0] == 'd'
          val.piece = Queen.new('W', key)
        elsif key[0] == 'e'
          val.piece = King.new('W', key)
        end
      elsif key[1] == 8
        if key[0] == 'a' || key[0] == 'h'
          val.piece = Rook.new('B', key)
        elsif key[0] == 'b' || key[0] == 'g'
          val.piece = Knight.new('B', key)
        elsif key[0] == 'c' || key[0] == 'f'
          val.piece = Bishop.new('B', key)
        elsif key[0] == 'd'
          val.piece = Queen.new('B', key)
        elsif key[0] == 'e'
          val.piece = King.new('B', key)
        end
      end
    end
  end

  def [](alpha, num)
    @cells[[alpha, num]] || nil
  end

  def []=(alpha, num, val)
    return nil unless @cells.has_key?([alpha, num])
    @cells[[alpha, num]] = val
  end

  def assign_adjacents(cells = @cells)
    cells.each_pair do |key, cell|
      INCREMENTS.each do |inc|
        sum = alpha_add(key, inc)
        adj = self[sum[0], sum[1]]
        cell.add_adjacents(adj) if !adj.nil?
      end
    end
  end

  def check_pos(pos)
    @cells.include?(pos)
  end

  def txt
    text = []
    i = 8
    until i <= 0 do
      text << " #{i}"
      ['a', 'b', 'c', 'd', 'e', 'f', 'g', 'h'].each do |char|
        cell = self[char, i]
        text << cell.txt
      end
      text << "\n"
      i -= 1
    end
    text << "   a  b  c  d  e  f  g  h\n"
    text.join('')
  end

end