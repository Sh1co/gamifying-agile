require_relative 'anomaly/anomaly'

class Action
  # @abstract
  attr_reader :strength

  def can_apply(anomaly)
    raise NotImplementedError, "#{self.class} has not implemented method '#{__method__}'"
  end

  def apply(anomaly, state)
    if self.can_apply?(anomaly)
      anomaly.difficulty -= @strength
    else
      anomaly.difficulty += @strength
    end
    state.update
  end
end

class ThinkReallyHard < Action
  def initialize
    @strength = 2
  end

  def can_apply?(anomaly)
    anomaly.is_a?(Bug)
  end
end