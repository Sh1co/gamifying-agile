require_relative 'util_classes/solid_object'

class Cauldron < SolidObject
  attr_accessor :x, :y, :image, :ingredients

  def initialize(x, y, image)
    @x = x
    @y = y
    @image = image
    @ingredients = []
  end

  def draw
    @image.draw_rot(@x, @y, 3, 0)
  end
end
