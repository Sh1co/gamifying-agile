require_relative '../entities/hero'
require_relative '../entities/portal'
require 'gosu'
require 'gosu_texture_packer'
require_relative '../constants'
require_relative '../entities/camera'
require_relative '../entities/customer'
require_relative '../entities/order_request'
require_relative '../entities/feature'
require_relative '../game'


class GameState
  SPEED = 7
  BACKGROUND = Game.media_path('map.png')
  HERO_FILE = Game.media_path('character.json')
  CUSTOMER_FILE = Game.media_path('customer.json')

  def initialize
    @background = Gosu::Image.new(
      $window, BACKGROUND, false)
    @hero_image = Gosu::TexturePacker.load_json(HERO_FILE, :precise)
    @customer_image = Gosu::TexturePacker.load_json(CUSTOMER_FILE, :precise)
    @hero = Hero.new($window, @hero_image.frame('character.png'))
    @camera = Camera.new
  end

  def can_move_to?(hero, x, y)
    @customers.reduce(true) do |acc, curr|
      acc && x > 0 && x + hero.width < MAP_WIDTH && !(curr.x < x + hero.width && curr.x + 200 > x && curr.y < y + hero.height && curr.y + 150 > y) && y > 0 && y < MAP_HEIGHT + hero.height
    end
  end

  def self.switch(new_state)
    $window.state&.leave
    $window.state = new_state
    new_state.enter
  end

  def enter
  end

  def leave
  end

  def draw
  end

  def update
  end

  def needs_redraw?
    true
  end

  def button_down(id)
  end
end
