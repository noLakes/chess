require_relative 'cell'
require_relative 'pieces'

VACANT = "[ ]"
INCREMENTS = [[-1, 1], [0, 1], [1, 1], [1, 0], [1, -1], [0, -1], [-1, -1], [-1, 0]]

class Board
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

  def assign_adjacents(cells = @cells)
    cells.each_pair do |key, cell|
      INCREMENTS.each do |inc|
        x = (key[0].ord + inc[0]).chr
        y = key[1] + inc[1]
        adj = get_pos([x, y])
        cell.add_adjacents(adj) if !adj.nil?
      end
    end
  end

  def check_pos(pos)
    @cells.include?(pos)
  end

  def get_pos(pos)
    return nil unless check_pos(pos)
    @cells[pos]
  end

  def set_pos(pos, piece)
    return nil unless check_pos(pos)
    @cells[pos] = piece
  end

  def txt
    text = []
    i = 8
    until i <= 0 do
      text << " #{i}"
      ['a', 'b', 'c', 'd', 'e', 'f', 'g', 'h'].each do |char|
        cell = get_pos([char, i])
        text << cell.txt
      end
      text << "\n"
      i -= 1
    end
    text << "   a  b  c  d  e  f  g  h\n"
    text.join('')
  end

end