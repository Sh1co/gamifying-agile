require_relative 'anomalies.rb'

class Action
  # @abstract

  def action_applicable?(anomaly)
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

class Test < Action
  def to_s
    "'Test'"
  end
  def action_applicable?(anomaly)
    anomaly.is_a?(UntestedFeature)
  end
end

class Code < Action
  def to_s
    "'Code'"
  end
  def action_applicable?(anomaly)
    anomaly.is_a?(FeatureToImplement)
  end
end

class DesignSystem < PreventiveAction
  def to_s
    "'DesignSystem'"
  end
  def action_applicable?(anomaly)
    anomaly.is_a?(LackOfDesign)
  end
end

class CollectRequirements < PreventiveAction
  def to_s
    "'CollectRequirements'"
  end
  def action_applicable?(anomaly)
    anomaly.is_a?(NewRequirement)
  end
end
