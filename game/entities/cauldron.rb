class Cauldron
  attr_accessor :x, :y, :image, :ingredients

  def initialize(x, y, image)
    @x = x
    @y = y
    @image = image
    @ingredients = []
  end

  def width
    @image.width
  end

  def height
    @image.height
  end

  def draw
    image.draw(@x, @y, 3)
  end
end
