require_relative '../../constants'

class Interactive
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
  def is_hovered?(x, y, camera)
    camera_x = camera.x - (WINDOW_WIDTH/2)
    camera_y = camera.y - (WINDOW_HEIGHT/2)
    x > self.left_border - camera_x && x < self.right_border - camera_x && y > self.top_border - camera_y && y < self.bottom_border - camera_y
  end
end