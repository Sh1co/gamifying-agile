require_relative 'actions.rb'
require_relative 'anomaly/anomaly.rb'
require_relative 'task/task.rb'

class DevelopmentProcessState
  # @abstract
  attr_accessor :next_states,
                :anomalies,
                :actions,
                :current_tasks
  attr_reader :task_context, :anomalies_context

  def initialize
  end
  def advance_task(feature)
    raise NotImplementedError, "#{self.class} has not implemented method '#{__method__}'"
  end
  def can_transition_state?(state)
    raise NotImplementedError, "#{self.class} has not implemented method '#{__method__}'"
  end
  def update
    raise NotImplementedError, "#{self.class} has not implemented method '#{__method__}'"
  end
end

class DevelopmentProcess
  # @abstract
  attr_accessor :state

  def initialize(state)
    @state = state
  end

  def advance_state(state)
    raise NotImplementedError, "#{self.class} has not implemented method '#{__method__}'"
  end
end
