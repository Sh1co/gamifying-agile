require_relative '../game_state'

class WaterfallState < GameState
  def initialize
    super
  end
  def update
    self.class.superclass.instance_method(:update).bind(self).call
  end
end
