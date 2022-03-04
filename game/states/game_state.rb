require 'gosu'
require 'gosu_texture_packer'
require_relative '../constants'
require_relative '../entities/camera'
require_relative '../entities/customer'
require_relative '../entities/order_request'
require_relative '../entities/feature'
require_relative '../entities/hero'
require_relative '../entities/portal'
require_relative '../entities/cauldron'
require_relative '../utils'


class GameState
  SPEED = 7
  BACKGROUND = Utils.media_path('map.png')
  HERO_FILE = Utils.media_path('character.json')
  CUSTOMER_FILE = Utils.media_path('customer.json')
  EMPTY_CAULDRON_FILE = Utils.media_path('pot.png')

  def initialize
    @background = Gosu::Image.new(
      $window, BACKGROUND, false)
    @hero_image = Gosu::TexturePacker.load_json(HERO_FILE, :precise)
    @customer_image = Gosu::TexturePacker.load_json(CUSTOMER_FILE, :precise)
    @hero = Hero.new($window, @hero_image.frame('character.png'))
    @cauldron = Cauldron.new(500, 500, Gosu::Image.new($window, EMPTY_CAULDRON_FILE, false))
    @camera = Camera.new
  end

  def will_not_collide?(obj1, obj2, obj1_new_x, obj1_new_y)
    !(obj2.x < obj1_new_x + obj1.width && obj2.x + obj2.width > obj1_new_x && obj2.y < obj1_new_y + obj1.height && obj2.y + obj2.height > obj1_new_y)
  end

  def can_move_to?(hero, x, y)
    will_not_collide?(hero, @cauldron, x, y) && x > 0 && x + hero.width < MAP_WIDTH && y > 0 && y < MAP_HEIGHT + hero.height && @customers.reduce(true) do |acc, curr|
      acc && will_not_collide?(hero, curr, x, y)
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

  def update_hero_position
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

  def update
  end

  def needs_redraw?
    true
  end

  def button_down(id)
  end

  def button_up(id)
  end
end
