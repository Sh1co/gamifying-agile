class GameWindow < Gosu::Window
  attr_accessor :state

  def initialize
    super(1920, 1080, false)
  end

  def update
    @state.update
  end

  def draw
    @state.draw
  end

  def needs_redraw?
    @state.needs_redraw?
  end

  def button_down(id)
    @state.button_down(id)
  end

  def button_up(id)
    @state.button_up(id)
  end
end