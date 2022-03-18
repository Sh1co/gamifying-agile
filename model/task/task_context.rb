class TaskContext
  def initialize(strategy)
    @strategy = strategy
  end

  def can_advance_task?(task, state)
    @strategy.can_advance_task?(task, state)
  end
end

class TaskAdvancingStrategy
  # @abstract
  def can_advance_task?(task, state)
    raise NotImplementedError, "#{self.class} has not implemented method '#{__method__}'"
  end
end

class WaterfallTaskAdvancingStrategy < TaskAdvancingStrategy
  def can_advance_task?(task, state)
    !state.anomalies.reduce(false) {|acc, anomaly| acc || anomaly.blocking_tasks.include?(task.class)}
  end
end
