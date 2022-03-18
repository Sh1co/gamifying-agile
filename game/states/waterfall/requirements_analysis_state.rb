require_relative '../../entities/hero'
require_relative '../../entities/portal'
require 'gosu'
require 'gosu_texture_packer'
require_relative '../../constants'
require_relative '../../entities/camera'
require_relative '../../entities/customer'
require_relative '../../entities/order_request'
require_relative '../../entities/task'
require_relative '../game_state'
require_relative '../menu_state'
require_relative './design_state'
require_relative 'waterfall_state'

class RequirementsAnalysisState < WaterfallState

  def initialize
    super()
    @customers = [
      Customer.new($window, 1200, 500, @customer_image.frame('customer.png'), OrderRequest.new($window, [FlyingFeature.new], 100)),
      Customer.new($window, 1200, 700, @customer_image.frame('customer.png'), nil),
      Customer.new($window, 1200, 900, @customer_image.frame('customer.png'), nil)
    ]
    @open_order = nil
    @next_state = DesignState
  end

  def button_down(id)
    if id == Gosu::MsLeft
      if !@open_order.nil?
        if $window.mouse_x > WINDOW_WIDTH/2 + 10 && $window.mouse_x < WINDOW_WIDTH/2 + 110 && $window.mouse_y > 790 && $window.mouse_y < 840
          GameState.switch(@next_state.new @open_order, @open_order.features)
        elsif $window.mouse_x > WINDOW_WIDTH/2 - 110 && $window.mouse_x < WINDOW_WIDTH/2 - 10 && $window.mouse_y > 790 && $window.mouse_y < 840
          @open_order = nil
        end
      else
        have_order = @customers.select { |customer| customer.has_order? }
        have_order.each do |customer|
          @open_order = customer.order if customer.was_clicked?($window.mouse_x, $window.mouse_y)
        end
      end
    end
  end

  def update
    if @open_order.nil?
      update_hero_position
    end
  end

  def draw
    off_x = -@camera.x + $window.width / 2
    off_y = -@camera.y + $window.height / 2
    $window.translate(off_x, off_y) do
      @background.draw(0, 0, 0)
      @hero.draw
      @customers.each { |customer| customer.draw }
      @cauldron.draw
    end
    unless @open_order.nil?
      @open_order.draw
    end
  end
end
