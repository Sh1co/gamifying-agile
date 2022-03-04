require 'gosu'

def media_path(file)
  File.join(File.dirname(File.dirname(
    __FILE__)), 'media', file)
end

class StaticAnimation
  FRAME_DELAY = 10 # ms

  def self.load_animation(tile, window)
    Gosu::Image.load_tiles(
      window, media_path(tile), 192, 192, false)
  end

  def initialize(animation, x, y)
    @animation = animation
    @x, @y = x, y
    @current_frame = 0
  end

  def update
    @current_frame += 1 if frame_expired?
  end

  def draw
    return if done?
    image = current_frame
    image.draw(
      @x - image.width / 2.0,
      @y - image.height / 2.0,
      0)
  end

  def done?
    @done ||= @current_frame == @animation.size
  end

  private

  def current_frame
    @animation[@current_frame % @animation.size]
  end

  def frame_expired?
    now = Gosu.milliseconds
    @last_frame ||= now
    if (now - @last_frame) > FRAME_DELAY
      @last_frame = now
    end
  end
end

class DynamicAnimation
  FRAME_DELAY = 10 # ms

  def self.load_animation(tile, window)
    Gosu::Image.load_tiles(
      window, media_path(tile), 192, 192, false)
  end

  def initialize(animation, x1, y1, x2, y2)
    @animation = animation
    @x1, @y1, @x2, @y2 = x1, y1, x2, y2
    @current_frame = 0
  end

  def update
    @current_frame += 1 if frame_expired?
  end

  def draw
    return if done?
    image = current_frame
    image.draw(
      @x1 - image.width / 2.0 + ((@x2 - @x1)/@animation.size)*@current_frame,
      @y1 - image.height / 2.0 + ((@y2 - @y1)/@animation.size)*@current_frame,
      0)
  end

  def done?
    @done ||= @current_frame == @animation.size
  end

  private

  def current_frame
    @animation[@current_frame % @animation.size]
  end

  def frame_expired?
    now = Gosu.milliseconds
    @last_frame ||= now
    if (now - @last_frame) > FRAME_DELAY
      @last_frame = now
    end
  end
end