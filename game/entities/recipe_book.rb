require_relative 'ingredient'

class RecipeBook
  attr_accessor :ingredients
  def initialize(window)
    @window = window
    @ingredients = [
      FeatherIngredient.new(window)
    ]
  end

  def draw
    color = Gosu::Color.new(100, 0, 0, 0)
    @window.draw_quad(
      0, 0, color,
      1920, 0, color,
      1920, 1080, color,
      0, 1080, color,
      200)
    book = Gosu::Image.new(
      @window, Utils.media_path('recipe_book.png'), false)
    book.draw(0, 0, 300)

    @ingredients[0].draw(0)
    # budget = Gosu::Image.from_text(
    #   $window, "Budget: #{@budget}",
    #   Gosu.default_font_name, 50)
    # budget.draw(800, 300, 301)

    #
    # @window.draw_quad(
    #   WINDOW_WIDTH/2 + 10, 790, Gosu::Color::GREEN,
    #   WINDOW_WIDTH/2 + 110, 790, Gosu::Color::GREEN,
    #   WINDOW_WIDTH/2 + 110, 840, Gosu::Color::GREEN,
    #   WINDOW_WIDTH/2 + 10, 840, Gosu::Color::GREEN,
    #   301)
    # Gosu::Image.from_text(
    #   $window, "Accept",
    #   Gosu.default_font_name, 30).draw(WINDOW_WIDTH/2 + 20, 800, 302)
    #
    # @window.draw_quad(
    #   WINDOW_WIDTH/2 - 110, 790, Gosu::Color::GRAY,
    #   WINDOW_WIDTH/2 - 10, 790, Gosu::Color::GRAY,
    #   WINDOW_WIDTH/2 - 10, 840, Gosu::Color::GRAY,
    #   WINDOW_WIDTH/2 - 110, 840, Gosu::Color::GRAY,
    #   301)
    # Gosu::Image.from_text(
    #   $window, "Cancel",
    #   Gosu.default_font_name, 30).draw(WINDOW_WIDTH/2 - 100, 800, 302)
  end
end
