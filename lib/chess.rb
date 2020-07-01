
class Game
  attr_reader :board, :turn, :players

  def initialize
    @board = build_board
    @players = {'White' => 'W', 'Black' => 'B'}
    @turn = @players['White']
  end


  def build_board
    board = {}
    files = ['a', 'b', 'c', 'd', 'e', 'f', 'g', 'h']
    ranks = [1, 2, 3, 4, 5, 6, 7, 8]

    files.each do |file|
      ranks.each do |rank|
        board["#{file}#{rank}"] = nil
      end
    end
    board
  end

  def check_pos(pos)
    @board.include?(pos)
  end

  def get_pos(pos)
    return nil unless check_pos(pos)
    @board[pos]
  end

  def set_pos(pos, val)
    return nil unless check_pos(pos)
    @board[pos] = val
  end

end