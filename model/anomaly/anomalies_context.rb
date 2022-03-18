require_relative 'anomaly'

class AnomaliesContext
  def initialize(strategy)
    @strategy = strategy
  end

  def generate_anomalies(state)
    @strategy.generate_anomalies state
  end
end

class AnomaliesGenerationStrategy
  # @abstract
  def generate_anomalies(state)
    raise NotImplementedError, "#{self.class} has not implemented method '#{__method__}'"
  end
end

class SimpleAnomaliesGenerationStrategy < AnomaliesGenerationStrategy
  def generate_anomalies(state)
    # if state.anomalies.length >= 3
    #   []
    # else
    #   if rand < 0.15
    #     [Bug.new]
    #   else
    #     []
    #   end
    # end
    []
  end
end
