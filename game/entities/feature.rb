require 'gosu'

class Feature
  attr_reader :name, :image, :big_image
end

class FlyingFeature < Feature
  def initialize
    @name = 'Flying'
    @image = Gosu::Image.new(
      $window, Utils.media_path('flying_icon.png'), false)
    @big_image = Gosu::Image.new(
      $window, Utils.media_path('flying_icon_big.png'), false)
  end
end