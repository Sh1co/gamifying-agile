require 'gosu'
require 'gosu_texture_packer'
require_relative '../../constants'
require_relative 'waterfall_state'
require_relative '../../entities/ingredient'

class TestingState < WaterfallState
  CAULDRON_WITH_POTION_FILE = Utils.media_path('pot_potion.png')

  def initialize(order, tasks)
    super()
    @customers = [
      Customer.new($window, 1200, 500, @customer_image.frame('customer.png'), nil),
      Customer.new($window, 1200, 700, @customer_image.frame('customer.png'), nil),
      Customer.new($window, 1200, 900, @customer_image.frame('customer.png'), nil)
    ]
  end

  def draw
    message = Gosu::Image.from_text(
      $window, "You won!",
      Gosu.default_font_name, 100)
    message.draw(
      $window.width / 2 - @message.width / 2,
      $window.height / 2 - @message.height / 2,
      10)
  end
end
