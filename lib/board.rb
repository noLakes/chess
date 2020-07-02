require 'pieces.rb'
require 'cell.rb'

class Board
  attr_reader :tiles

  def initialize
    @tiles = build_board
  end

  VACANT = "[ ]"

  def build_board
    tiles = {}
    files = ['a', 'b', 'c', 'd', 'e', 'f', 'g', 'h']
    ranks = [1, 2, 3, 4, 5, 6, 7, 8]

    files.each do |file|
      ranks.each do |rank|
        tiles["#{file}#{rank}"] = VACANT
      end
    end
    tiles
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
        cell = get_pos("#{char}#{i}")
        cell == VACANT ? text << cell : text << cell.txt
      end
      text << "\n"
      i -= 1
    end
    text << "   a  b  c  d  e  f  g  h\n"
    text.join('')
  end

end