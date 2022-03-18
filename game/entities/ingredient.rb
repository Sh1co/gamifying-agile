require_relative 'task'

class Ingredient
  attr_reader :window, :name, :image, :big_image, :cost, :features
  def draw(page)
    title = Gosu::Image.from_text(
      @window, @name,
      Gosu.default_font_name, 100)
    cost = Gosu::Image.from_text(
      @window, "License Cost: #{@cost}",
      Gosu.default_font_name, 50)
    if page == 0
      title.draw(420, 200, 301)
      @big_image.draw(730, 200, 301)
      cost.draw(420, 300, 301)
      Gosu::Image.from_text(
        @window, "Features:",
        Gosu.default_font_name, 50).draw(420, 350, 301)
      @features.each_with_index do |feature, idx|
        Gosu::Image.from_text(
          @window, "- #{feature.name}",
          Gosu.default_font_name, 50).draw(420, 400 + idx*10, 301)
      end
      @window.draw_quad(
        WINDOW_WIDTH/2 - 220, 790, Gosu::Color::GREEN,
        WINDOW_WIDTH/2 - 70, 790, Gosu::Color::GREEN,
        WINDOW_WIDTH/2 - 70, 840, Gosu::Color::GREEN,
        WINDOW_WIDTH/2 - 220, 840, Gosu::Color::GREEN,
        301)
      Gosu::Image.from_text(
        $window, "Buy licence",
        Gosu.default_font_name, 30).draw(WINDOW_WIDTH/2 - 210, 800, 302)
    end
  end
end

class FeatherIngredient < Ingredient
  attr_accessor :image
  def initialize(window)
    @window = window
    @name = 'Feather'
    @cost = 100
    @features = [
      FlyingFeature.new
    ]
    @image = Gosu::Image.new(
      @window, Utils.media_path('feather.png'), false)
    @big_image = Gosu::Image.new(
      @window, Utils.media_path('feather_big.png'), false)
  end

  def draw_task(x, y)
    Gosu::Image.new(
      $window, Utils.media_path('pink_icon.png'), false).draw(x, y, 201)
    @big_image.draw(x + 50, y + 20, 201)
  end
end

class CollectableIngredient
  attr_accessor :x, :y, :ingredient

  def initialize(ingredient, x, y)
    @ingredient = ingredient
    @x = x
    @y = y
  end

  def draw
    @ingredient.image.draw(@x, @y, 2)
  end
end

class CollectedIngredient
  attr_accessor :x, :y, :home_x, :home_y, :ingredient

  def initialize(ingredient, x, y)
    @ingredient = ingredient
    @x = x
    @home_x = x
    @y = y
    @home_y = y
  end

  def draw
    @ingredient.image.draw(@x, @y, 201)
  end
end
