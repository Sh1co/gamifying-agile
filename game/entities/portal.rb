require_relative '../locations/location'

class Portal
  attr_reader :x, :y, :to_idx

  def initialize(window, image, x, y, to_idx)
    @window = window
    @image = image
    @x = x
    @y = y
    @to_idx = to_idx
  end

  def draw
    @image.draw(@x, @y, 0)
  end
end
