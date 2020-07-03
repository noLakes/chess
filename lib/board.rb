require 'pieces.rb'
require 'cell.rb'

VACANT = "[ ]"

class Board
  attr_reader :tiles

  def initialize
    @tiles = build_board
  end

  def build_board
    tiles = {}
    files = ['a', 'b', 'c', 'd', 'e', 'f', 'g', 'h']
    ranks = [1, 2, 3, 4, 5, 6, 7, 8]

    files.each do |file|
      ranks.each do |rank|
        tiles[[file, rank]] = Cell.new([file, rank])
      end
    end
    tiles
  end

  def add_adjacents(board)
  end

  def check_pos(pos)
    @tiles.include?(pos)
  end

  def get_pos(pos)
    return nil unless check_pos(pos)
    @tiles[pos]
  end

  def set_pos(pos, val)
    return nil unless check_pos(pos)
    @tiles[pos] = val
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