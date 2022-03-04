class Portal
  attr_accessor :x, :y

  def initialize(window, image, x, y)
    @window = window
    @image = image
    @x = x
    @y = y
  end

  def draw
    @image.draw(@x, @y, 0)
  end
end
