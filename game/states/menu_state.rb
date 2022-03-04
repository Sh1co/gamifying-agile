require 'singleton'
require_relative 'game_state'
require_relative 'waterfall/requirements_analysis_state'

class MenuState < GameState
  include Singleton
  attr_accessor :play_state

  def initialize
    @message = Gosu::Image.from_text(
      $window, "Gamifying Agile",
      Gosu.default_font_name, 100)
  end

  def enter
  end

  def leave
  end

  def update
    continue_text = @play_state ? "C = Continue, " : ""
    @info = Gosu::Image.from_text(
      $window, "Q = Quit, #{continue_text}W = Waterfall Utils",
      Gosu.default_font_name, 30)
  end

  def draw
    @message.draw(
      $window.width / 2 - @message.width / 2,
      $window.height / 2 - @message.height / 2,
      10)
    @info.draw(
      $window.width / 2 - @info.width / 2,
      $window.height / 2 - @info.height / 2 + 200,
      10)
  end

  def button_down(id)
    $window.close if id == Gosu::KbQ
    if id == Gosu::KbC && @play_state
      GameState.switch(@play_state)
    end
    if id == Gosu::KbW
      @play_state = RequirementsAnalysisState.new
      GameState.switch(@play_state)
    end
    if id == Gosu::KbC
      GameState.switch(@play_state)
    end
  end
end