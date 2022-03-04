require_relative '../../entities/hero'
require_relative '../../entities/portal'
require 'gosu'
require 'gosu_texture_packer'
require_relative '../../constants'
require_relative '../../entities/camera'
require_relative '../../entities/customer'
require_relative '../../entities/order_request'
require_relative '../../entities/feature'
require_relative '../game_state'
require_relative '../menu_state'
require_relative './design_state'
require_relative 'waterfall_state'

class ImplementationState < WaterfallState

  def initialize(order, tasks)
    super()
    @customers = [
      Customer.new($window, 1200, 500, @customer_image.frame('customer.png'), nil),
      Customer.new($window, 1200, 700, @customer_image.frame('customer.png'), nil),
      Customer.new($window, 1200, 900, @customer_image.frame('customer.png'), nil)
    ]

    @features_to_implement = tasks
    @implemented_features = []
  end

  def update
    if $window.button_down?(Gosu::KbA) && can_move_to?(@hero, @hero.x - SPEED, @hero.y)
      if @camera.x > WINDOW_WIDTH / 2 && @hero.x < (MAP_WIDTH - WINDOW_WIDTH / 2)
        @camera.x -= SPEED
      end
      @hero.x -= SPEED
      @hero.w_x = @hero.x - (@camera.x - WINDOW_WIDTH / 2)
    end

    if $window.button_down?(Gosu::KbD) && can_move_to?(@hero, @hero.x + SPEED, @hero.y)
      if @camera.x < (MAP_WIDTH - WINDOW_WIDTH / 2) && @hero.x > (WINDOW_WIDTH / 2)
        @camera.x += SPEED
      end
      @hero.x += SPEED
      @hero.w_x = @hero.x - (@camera.x - WINDOW_WIDTH / 2)
    end
    if $window.button_down?(Gosu::KbW) && can_move_to?(@hero, @hero.x, @hero.y - SPEED)
      if @camera.y > WINDOW_HEIGHT / 2 && @hero.y < (MAP_HEIGHT - WINDOW_HEIGHT / 2)
        @camera.y -= SPEED
      end
      @hero.y -= SPEED
      @hero.w_y = @hero.y - (@camera.y - WINDOW_HEIGHT / 2)
    end
    if $window.button_down?(Gosu::KbS) && can_move_to?(@hero, @hero.x, @hero.y + SPEED)
      if @camera.y < (MAP_HEIGHT - WINDOW_HEIGHT / 2) && @hero.y > (WINDOW_HEIGHT / 2)
        @camera.y += SPEED
      end
      @hero.y += SPEED
      @hero.w_y = @hero.y - (@camera.y - WINDOW_HEIGHT / 2)
    end
    @hero.update
  end

  def draw
    off_x = -@camera.x + $window.width / 2
    off_y = -@camera.y + $window.height / 2
    $window.translate(off_x, off_y) do
      @background.draw(0, 0, 0)
      @hero.draw
      @customers.each { |customer| customer.draw }
    end
  end
end
