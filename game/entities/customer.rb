require 'gosu'

class Customer
  attr_accessor :window, :x, :y, :image, :order

  def initialize(window, x, y, image, order)
    @window, @x, @y, @image, @order = window, x, y, image, order
    @bulb= Gosu::Image.new(
      $window, Utils.media_path('bulb.png'), false)
  end

  def has_order?
    !@order.nil?
  end

  def was_clicked?(x, y)
    x > @x && x < @x + @image.width && y > @y && y < @y + @image.height
  end

  def width
    @image.width
  end

  def height
    @image.height
  end

  def draw
    @image.draw(@x, @y, 1)
    if self.has_order?
      @bulb.draw(@x, @y, 2)
    end
  end
end
