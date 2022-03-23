class HUDElement
  def width
    @image.width
  end

  def height
    @image.height
  end

  def left_border
    @x - self.width/2
  end

  def right_border
    @x + self.width/2
  end

  def top_border
    @y - self.height/2
  end

  def bottom_border
    @y + self.height/2
  end

  def is_hovered?(x, y)
    x > self.left_border && x < self.right_border && y > self.top_border  && y < self.bottom_border
  end
end
