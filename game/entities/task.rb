require 'gosu'

class Spec
  attr_reader :name, :image, :big_image
end

class FlyingFeature < Spec
  def initialize
    @name = 'Flying'
    @image = Gosu::Image.new(
      $window, Utils.media_path('flying_icon.png'), false)
    @big_image = Gosu::Image.new(
      $window, Utils.media_path('flying_icon_big.png'), false)
  end

  def draw_completed(x, y)
    Gosu::Image.new(
      $window, Utils.media_path('green_icon.png'), false).draw(x, y, 201)
    @big_image.draw(x, y, 201)
  end
end

class LoveFeature < Spec
  def initialize
    @name = 'Love'
    @image = Gosu::Image.new(
      $window, Utils.media_path('heart.png'), false)
    @big_image = Gosu::Image.new(
      $window, Utils.media_path('heart_big.png'), false)
  end

  def draw_completed(x, y)
    Gosu::Image.new(
      $window, Utils.media_path('green_icon.png'), false).draw(x, y, 201)
    @big_image.draw(x, y, 201)
  end
end

class DeathFeature < Spec
  def initialize
    @name = 'Death'
    @image = Gosu::Image.new(
      $window, Utils.media_path('skull.png'), false)
    @big_image = Gosu::Image.new(
      $window, Utils.media_path('skull_big.png'), false)
  end

  def draw_completed(x, y)
    Gosu::Image.new(
      $window, Utils.media_path('green_icon.png'), false).draw(x, y, 201)
    @big_image.draw(x, y, 201)
  end
end