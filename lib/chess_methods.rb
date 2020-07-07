
module Chess_methods

  def alpha_add(pos, inc)
    x = (pos[0].ord + inc[0]).chr
    y = pos[1] + inc[1]
    [x, y]
  end

end