require 'gosu'
require 'gosu_texture_packer'
require_relative '../constants'
require_relative '../entities/camera'
require_relative '../entities/customer'
require_relative '../entities/order_request'
require_relative '../entities/task'
require_relative '../entities/hero'
require_relative '../entities/portal'
require_relative '../entities/cauldron'
require_relative '../utils'
require_relative '../locations/location'

class GameState
  attr_accessor :next_states
  attr_reader :location

  def initialize
    @camera = Camera.new
  end

  def self.switch_state(new_state)
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

  def button_up(id)
  end
end
