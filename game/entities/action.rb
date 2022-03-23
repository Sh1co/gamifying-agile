require_relative 'util_classes/hud_element'
require_relative '../constants'

class Action < HUDElement
  attr_reader :strength, :image
  attr_accessor :x, :y, :is_selected

  def initialize(window, image, strength)
    @window = window
    @image = image
    @strength = strength
    @is_selected = false
  end

  def draw
    @image.draw_rot(@x, @y, 301, 0)
    text = Gosu::Image.from_text(
      @window, "#{@strength}",
      Gosu.default_font_name, 30)
    text.draw(@x + 10, @y + 10, 301)
  end

  def to_s
    "BLUE ACTION"
  end
end

class ActiveAction < Interactive
  attr_reader :x, :y, :action
  def initialize(window, camera, action, x, y)
    @action = action
    @image = action.image
    w_x = x - (camera.x - WINDOW_WIDTH / 2)
    w_y = y - (camera.y - WINDOW_HEIGHT / 2)
    @angle = -Math.atan2(w_x - window.mouse_x,
                      w_y - window.mouse_y) - 1.5
    @speed = action.strength
    @x = x
    @y = y
  end

  def draw
    @action.image.draw(@x, @y, 200)
  end

  def update
    @x = @x + (@speed * Math.cos(@angle))
    @y = @y + (@speed * Math.sin(@angle))
  end
end