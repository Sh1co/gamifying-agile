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
  CUSTOMER_FILE = Utils.media_path('customer.json')
  PORTAL_FILE = Utils.media_path('portal.png')
  EMPTY_CAULDRON_FILE = Utils.media_path('pot.png')

  def initialize
    super()
    customers = [            #x    y
      Customer.new($window, 1200, 500, Gosu::Image.new($window, Utils.media_path('customer1.png'), false), OrderRequest.new($window, [FlyingFeature.new, LoveFeature.new, DeathFeature.new], 150)),
      Customer.new($window, 1200, 700, Gosu::Image.new($window, Utils.media_path('customer2.png'), false), nil),
      Customer.new($window, 1200, 900, Gosu::Image.new($window, Utils.media_path('customer3.png'), false), nil),
      Customer.new($window, 1000, 300, Gosu::Image.new($window, Utils.media_path('customer3.png'), false), nil),
      Customer.new($window, 700, 300, Gosu::Image.new($window, Utils.media_path('customer2.png'), false), nil),
      Customer.new($window, 1400, 900, Gosu::Image.new($window, Utils.media_path('customer4.png'), false), nil),
      Customer.new($window, 1400, 700, Gosu::Image.new($window, Utils.media_path('customer5.png'), false), nil),
      Customer.new($window, 1400, 500, Gosu::Image.new($window, Utils.media_path('customer6.png'), false), nil),
      Customer.new($window, 700, 900, Gosu::Image.new($window, Utils.media_path('customer7.png'), false), nil),
      Customer.new($window, 500, 900, Gosu::Image.new($window, Utils.media_path('customer4.png'), false), nil),
      Customer.new($window, 300, 900, Gosu::Image.new($window, Utils.media_path('customer2.png'), false), nil),
      Customer.new($window, 300, 500, Gosu::Image.new($window, Utils.media_path('customer4.png'), false), nil),
      Customer.new($window, 500, 100, Gosu::Image.new($window, Utils.media_path('customer1.png'), false), nil),
      Customer.new($window, 500, 300, Gosu::Image.new($window, Utils.media_path('customer3.png'), false), nil),
      Customer.new($window, 300, 100, Gosu::Image.new($window, Utils.media_path('customer2.png'), false), nil),
      Customer.new($window, 300, 300, Gosu::Image.new($window, Utils.media_path('customer7.png'), false), nil),
      Customer.new($window, 300, 700, Gosu::Image.new($window, Utils.media_path('customer6.png'), false), nil),
      Customer.new($window, 700, 100, Gosu::Image.new($window, Utils.media_path('customer6.png'), false), nil),
      Customer.new($window, 900, 100, Gosu::Image.new($window, Utils.media_path('customer4.png'), false), nil),
      Customer.new($window, 1100, 100, Gosu::Image.new($window, Utils.media_path('customer1.png'), false), nil),
      Customer.new($window, 1300, 100, Gosu::Image.new($window, Utils.media_path('customer5.png'), false), nil),
      Customer.new($window, 1300, 300, Gosu::Image.new($window, Utils.media_path('customer2.png'), false), nil),
      Customer.new($window, 1500, 200, Gosu::Image.new($window, Utils.media_path('customer7.png'), false), nil),
    ]
    portals = [
      Portal.new($window, Gosu::Image.new($window, PORTAL_FILE, false), 2000, 300, nil)
    ]
    cauldron = Cauldron.new(500, 500, Gosu::Image.new($window, EMPTY_CAULDRON_FILE, false))
    @location = VillageLocation.new customers, cauldron, portals
    @open_order = nil
    @next_states = DesignState
  end

  def button_down(id)
    if id == Gosu::MsLeft
      if !@open_order.nil?
        if $window.mouse_x > WINDOW_WIDTH/2 + 10 && $window.mouse_x < WINDOW_WIDTH/2 + 110 && $window.mouse_y > 790 && $window.mouse_y < 840
          GameState.switch_state(@next_states.new @open_order, @open_order.features)
        elsif $window.mouse_x > WINDOW_WIDTH/2 - 110 && $window.mouse_x < WINDOW_WIDTH/2 - 10 && $window.mouse_y > 790 && $window.mouse_y < 840
          @open_order = nil
        end
      else
        have_order = @location.customers.select { |customer| customer.has_order? }
        have_order.each do |customer|
          @open_order = customer.order if customer.is_hovered?($window.mouse_x, $window.mouse_y, @camera)
        end
      end
    end
  end

  def update
    if @open_order.nil?
      @location.update_hero_position($window, @camera)
    end
  end

  def draw
    @location.draw($window, @camera)
    unless @open_order.nil?
      @open_order.draw
    end
  end
end
