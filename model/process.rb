require_relative 'actions.rb'
require_relative 'anomalies.rb'
require_relative 'features.rb'

class DevelopmentProcessState
  # @abstract
  def initialize
  end
  def advance_feature(feature)
    raise NotImplementedError, "#{self.class} has not implemented method '#{__method__}'"
  end
  def can_transition_state?
    raise NotImplementedError, "#{self.class} has not implemented method '#{__method__}'"
  end
end

class DevelopmentProcess
  # @abstract
  attr_accessor :state

  def initialize(state)
    @state = state
  end

  def advance_state
    raise NotImplementedError, "#{self.class} has not implemented method '#{__method__}'"
  end
end
