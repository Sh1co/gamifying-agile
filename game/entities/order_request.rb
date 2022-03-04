require 'gosu'
require_relative '../constants'

class OrderRequest
  attr_accessor :features, :budget
  def initialize(window, features, budget)
    @features = features
    @budget = budget
    @window = window
  end

  def draw
    color = Gosu::Color.new(100, 0, 0, 0)
    @window.draw_quad(
      0, 0, color,
      1920, 0, color,
      1920, 1080, color,
      0, 1080, color,
      200)
    parchment = Gosu::Image.new(
      @window, Utils.media_path('parchment.png'), false)
    parchment.draw(0, 0, 300)
    title = Gosu::Image.from_text(
      $window, "Order",
      Gosu.default_font_name, 100)
    title.draw(800, 200, 301)
    budget = Gosu::Image.from_text(
      $window, "Budget: #{@budget}",
      Gosu.default_font_name, 50)
    budget.draw(800, 300, 301)
    @features.each_with_index do |feature, idx|
      text = Gosu::Image.from_text(
        $window, "- #{feature.name}",
        Gosu.default_font_name, 30)
      text.draw(800, 400 + 100*idx, 301)
      feature.image.draw(890, 390 + 100*idx, 301)
    end

    @window.draw_quad(
      WINDOW_WIDTH/2 + 10, 790, Gosu::Color::GREEN,
      WINDOW_WIDTH/2 + 110, 790, Gosu::Color::GREEN,
      WINDOW_WIDTH/2 + 110, 840, Gosu::Color::GREEN,
      WINDOW_WIDTH/2 + 10, 840, Gosu::Color::GREEN,
      301)
    Gosu::Image.from_text(
      $window, "Accept",
      Gosu.default_font_name, 30).draw(WINDOW_WIDTH/2 + 20, 800, 302)

    @window.draw_quad(
      WINDOW_WIDTH/2 - 110, 790, Gosu::Color::GRAY,
      WINDOW_WIDTH/2 - 10, 790, Gosu::Color::GRAY,
      WINDOW_WIDTH/2 - 10, 840, Gosu::Color::GRAY,
      WINDOW_WIDTH/2 - 110, 840, Gosu::Color::GRAY,
      301)
    Gosu::Image.from_text(
      $window, "Cancel",
      Gosu.default_font_name, 30).draw(WINDOW_WIDTH/2 - 100, 800, 302)
  end
end
