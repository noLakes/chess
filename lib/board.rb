require_relative 'cell'
Dir["/pieces/*"].each {|file| require file }

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

  def [](alpha, num)
    @cells[[alpha, num]] || nil
  end

  def assign_adjacents(cells = @cells)
    cells.each_pair do |key, cell|
      INCREMENTS.each do |inc|
        x = (key[0].ord + inc[0]).chr
        y = key[1] + inc[1]
        adj = self[x, y]
        cell.add_adjacents(adj) if !adj.nil?
      end
    end
  end

  def check_pos(pos)
    @cells.include?(pos)
  end

  def set_pos(pos, val)
    return nil unless check_pos(pos)
    @cells[pos] = val
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