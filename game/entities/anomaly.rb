require_relative 'util_classes/solid_object'

class Anomaly < SolidObject
  attr_accessor :difficulty, :x, :y

  def initialize(window, x, y, image, diff)
    @window = window
    @x = x
    @y = y
    @image = image
    @difficulty = diff
    @body_angle = 0.0
  end

  def draw
    @image.draw_rot(@x, @y, 1, @body_angle)
    text = Gosu::Image.from_text(
      @window, "#{@difficulty}",
      Gosu.default_font_name, 30)
    text.draw(@x - 60, @y - 60, 100)
  end
end
