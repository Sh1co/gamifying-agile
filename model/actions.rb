class Action
  # @abstract
  @id

  def initialize(id)
    @id = id
  end
  def applyAction(anomaly)
    raise NotImplementedError, "#{self.class} has not implemented method '#{__method__}'"
  end
end

class PreventiveAction < Action
  # @abstract
end
class CorrectiveAction < Action
  # @abstract
end
class AdaptiveAction < Action
  # @abstract
end

class Retrospective < AdaptiveAction
  def applyAction(anomaly)
    # Need real implementation
    puts "Applying #{self.class} to #{anomaly.to_s}"
  end
end
class WeeklyStandups < AdaptiveAction
  def applyCorrectiveAction(anomaly)
    # Need real implementation
    puts "Applying #{self.class} to #{anomaly.to_s}"
  end
end
class RestartServer < CorrectiveActions
  def applyCorrectiveAction(anomaly)
    # Need real implementation
    puts "Applying #{self.class} to #{anomaly.to_s}"
  end
end
class RequirementsAnalysis < PreventiveAction
  def applyCorrectiveAction(anomaly)
    # Need real implementation
    puts "Applying #{self.class} to #{anomaly.to_s}"
  end
end