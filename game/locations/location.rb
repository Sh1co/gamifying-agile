require_relative '../constants'
require_relative '../utils'
require_relative '../entities/anomaly'
require_relative '../entities/util_classes/solid_object'

class Location
  attr_accessor :background, :hero

  def initialize
  end

  def on_enter
  end

  def on_leave
  end
end

class VillageLocation < Location
  SPEED = 7
  BACKGROUND = Utils.media_path('map_swamp.png')
  HERO_FILE = Utils.media_path('character.png')

  attr_reader :customers, :portals, :anomalies, :mode
  attr_accessor :cauldron, :hero

  def initialize(customers, cauldron, portals)
    @background = Gosu::Image.new(
      $window, BACKGROUND, false)
    hero_image = Gosu::Image.new(
      $window, HERO_FILE, false)
    @hero = Hero.new($window, hero_image)
    @customers = customers
    @cauldron = cauldron
    @portals = portals
    @anomalies = Array[]
    @mode = :peaceful
  end

  def can_move_to?(hero, x, y)
    SolidObject.will_not_collide?(hero, @cauldron, x, y) &&
      x - hero.width/2  > 0 && x + hero.width/2 < MAP_WIDTH && y - hero.height/2 > 0 && y + hero.height/2  < MAP_HEIGHT &&
      @customers.reduce(true) do |acc, curr|
        acc && SolidObject.will_not_collide?(hero, curr, x, y)
      end
  end

  def on_enter
    @hero.x = @hero.x - 20
  end

  def draw(window, camera)
    off_x = -camera.x + window.width / 2
    off_y = -camera.y + window.height / 2
    window.translate(off_x, off_y) do
      @background.draw(0, 0, 0)
      @hero.draw
      @customers.each { |customer| customer.draw }
      @portals.each { |portal| portal.draw }
      @cauldron.draw
    end
  end

  def update_hero_position(window, camera)
    if window.button_down?(Gosu::KbA) && can_move_to?(@hero, @hero.x - SPEED, @hero.y)
      if camera.x > WINDOW_WIDTH / 2 && @hero.x < (MAP_WIDTH - WINDOW_WIDTH / 2)
        camera.x -= SPEED
      end
      @hero.x -= SPEED
      @hero.w_x = @hero.x - (camera.x - WINDOW_WIDTH / 2)
    end

    if window.button_down?(Gosu::KbD) && can_move_to?(@hero, @hero.x + SPEED, @hero.y)
      if camera.x < (MAP_WIDTH - WINDOW_WIDTH / 2) && @hero.x > (WINDOW_WIDTH / 2)
        camera.x += SPEED
      end
      @hero.x += SPEED
      @hero.w_x = @hero.x - (camera.x - WINDOW_WIDTH / 2)
    end
    if window.button_down?(Gosu::KbW) && can_move_to?(@hero, @hero.x, @hero.y - SPEED)
      if camera.y > WINDOW_HEIGHT / 2 && @hero.y < (MAP_HEIGHT - WINDOW_HEIGHT / 2)
        camera.y -= SPEED
      end
      @hero.y -= SPEED
      @hero.w_y = @hero.y - (camera.y - WINDOW_HEIGHT / 2)
    end
    if window.button_down?(Gosu::KbS) && can_move_to?(@hero, @hero.x, @hero.y + SPEED)
      if camera.y < (MAP_HEIGHT - WINDOW_HEIGHT / 2) && @hero.y > (WINDOW_HEIGHT / 2)
        camera.y += SPEED
      end
      @hero.y += SPEED
      @hero.w_y = @hero.y - (camera.y - WINDOW_HEIGHT / 2)
    end
    @hero.update
  end
end

class SwampLocation < Location
  SPEED = 7
  BACKGROUND = Utils.media_path('map_swamp.png')
  HERO_FILE = Utils.media_path('character_top_view.png')
  ANOMALY_FILE1 = Utils.media_path('anomaly1.png')
  ANOMALY_FILE2 = Utils.media_path('anomaly2.png')
  ANOMALY_FILE3 = Utils.media_path('anomaly3.png')

  attr_reader :collectable_ingredients, :portals, :anomalies, :mode
  attr_accessor :active_actions

  def initialize(portals, collectable_ingredients)
    @background = Gosu::Image.new(
      $window, BACKGROUND, false)
    hero_image = Gosu::Image.new(
      $window, HERO_FILE, false)
    anomaly_image1 = Gosu::Image.new(
      $window, ANOMALY_FILE1, false)
    anomaly_image2 = Gosu::Image.new(
      $window, ANOMALY_FILE2, false)
    anomaly_image3 = Gosu::Image.new(
      $window, ANOMALY_FILE3, false)
    @hero = Hero.new($window, hero_image)
    @portals = portals
    @collectable_ingredients = collectable_ingredients
    @anomalies = [
      Anomaly.new($window, 1500, 500, anomaly_image1, 4),
      Anomaly.new($window, 1300, 700, anomaly_image2, 6),
      Anomaly.new($window, 1200, 300, anomaly_image3, 10),
    ]
    @active_actions = []
    @mode = :battle
  end

  def draw(window, camera)
    off_x = -camera.x + window.width / 2
    off_y = -camera.y + window.height / 2
    window.translate(off_x, off_y) do
      @background.draw(0, 0, 0)
      @hero.draw_rot
      @portals.each { |portal| portal.draw }
      @anomalies.each { |anomaly| anomaly.draw }
      @collectable_ingredients.each { |ing| ing.draw }
      @active_actions.each { |action| action.draw }
    end
  end

  def update_active_actions
    @active_actions.each { |action| action.update }
  end

  def on_enter
    @hero.x = @hero.x + 20
  end

  def can_move_to?(hero, x, y)
    x > 0 && x + hero.width < MAP_WIDTH && y > 0 && y < MAP_HEIGHT + hero.height && @anomalies.reduce(true) do |acc, curr|
      acc && SolidObject.will_not_collide?(hero, curr, x, y)
    end
  end

  def update_hero_position(window, camera)
    if window.button_down?(Gosu::KbA) && can_move_to?(@hero, @hero.x - SPEED, @hero.y)
      if camera.x > WINDOW_WIDTH / 2 && @hero.x < (MAP_WIDTH - WINDOW_WIDTH / 2)
        camera.x -= SPEED
      end
      @hero.x -= SPEED
      @hero.w_x = @hero.x - (camera.x - WINDOW_WIDTH / 2)
    end

    if window.button_down?(Gosu::KbD) && can_move_to?(@hero, @hero.x + SPEED, @hero.y)
      if camera.x < (MAP_WIDTH - WINDOW_WIDTH / 2) && @hero.x > (WINDOW_WIDTH / 2)
        camera.x += SPEED
      end
      @hero.x += SPEED
      @hero.w_x = @hero.x - (camera.x - WINDOW_WIDTH / 2)
    end
    if window.button_down?(Gosu::KbW) && can_move_to?(@hero, @hero.x, @hero.y - SPEED)
      if camera.y > WINDOW_HEIGHT / 2 && @hero.y < (MAP_HEIGHT - WINDOW_HEIGHT / 2)
        camera.y -= SPEED
      end
      @hero.y -= SPEED
      @hero.w_y = @hero.y - (camera.y - WINDOW_HEIGHT / 2)
    end
    if window.button_down?(Gosu::KbS) && can_move_to?(@hero, @hero.x, @hero.y + SPEED)
      if camera.y < (MAP_HEIGHT - WINDOW_HEIGHT / 2) && @hero.y > (WINDOW_HEIGHT / 2)
        camera.y += SPEED
      end
      @hero.y += SPEED
      @hero.w_y = @hero.y - (camera.y - WINDOW_HEIGHT / 2)
    end
    @hero.update
  end
end
