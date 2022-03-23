require_relative 'util_classes/solid_object'

class Hero < SolidObject
  attr_accessor :x, :y, :w_x, :w_y, :body_angle

  def initialize(window, body)
    @x = WINDOW_WIDTH / 2
    @y = WINDOW_HEIGHT / 2
    @w_x = WINDOW_WIDTH / 2
    @w_y = WINDOW_HEIGHT / 2
    @window = window
    @image = body
    @body_angle = 0.0
  end

  def update
    atan = Math.atan2(@w_x - @window.mouse_x,
                      @w_y - @window.mouse_y)
    @body_angle = -atan * 180 / Math::PI
  end

  def draw
    @image.draw_rot(@x, @y, 1, 0)
  end

  def draw_rot
    @image.draw_rot(@x, @y, 1, @body_angle)
  end

  private

  def change_angle(previous_angle, up, down, right, left)
    if @window.button_down?(up)
      angle = 0.0
      angle += 45.0 if @window.button_down?(left)
      angle -= 45.0 if @window.button_down?(right)
    elsif @window.button_down?(down)
      angle = 180.0
      angle -= 45.0 if @window.button_down?(left)
      angle += 45.0 if @window.button_down?(right)
    elsif @window.button_down?(left)
      angle = 90.0
      angle += 45.0 if @window.button_down?(up)
      angle -= 45.0 if @window.button_down?(down)
    elsif @window.button_down?(right)
      angle = 270.0
      angle -= 45.0 if @window.button_down?(up)
      angle += 45.0 if @window.button_down?(down)
    end
    angle || previous_angle
  end
end
