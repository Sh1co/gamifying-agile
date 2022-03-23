require 'gosu'
require_relative 'util_classes/solid_object'

class Customer < SolidObject
  attr_accessor :window, :x, :y, :image, :order

  def initialize(window, x, y, image, order)
    @window, @x, @y, @image, @order = window, x, y, image, order
    @bulb= Gosu::Image.new(
      $window, Utils.media_path('bulb.png'), false)
  end

  def has_order?
    !@order.nil?
  end

  def draw
    @image.draw_rot(@x, @y, 1, 0)
    if self.has_order?
      @bulb.draw_rot(@x - 10, @y - 10, 2, 0)
    end
  end
end
