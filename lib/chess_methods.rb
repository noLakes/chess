
module Chess_methods

  def alpha_add(pos, inc)
    x = (pos[0].ord + inc[0]).chr
    y = pos[1] + inc[1]
    [x, y]
  end

  def in_board(pos)
    pos[0].between?('a', 'h') && pos[1].between?(1, 8)
  end

  def get_in_range(pos, range)
    result = []
    range.each do |inc|
      new_pos = alpha_add(pos, inc)
      if in_board(new_pos)
        result << new_pos
      end
    end
    result
  end

end