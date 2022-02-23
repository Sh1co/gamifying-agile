require_relative '../process.rb'

class WaterfallState < DevelopmentProcessState
  attr_accessor :next_state,
                :features_from,
                :features_to,
                :anomalies,
                :actions
  def initialize(features)
    @features_from = features
  end

  def can_transition_state?
    self.is_a?(WaterfallMaintenance) || self.features_from.length == 0
  end
  def advance_feature(feature)
    raise NotImplementedError, "#{self.class} has not implemented method '#{__method__}'"
  end
end

class WaterfallDevelopmentProcess < DevelopmentProcess
  def initialize(state)
    super
  end

  def advance_state
    if self.state.can_transition_state?
      puts "Transitioning from #{self.state.to_s} to #{self.state.next_state.to_s}"
      self.state = self.state.next_state.new self.state.features_to
    else
      puts "Too early to go to the next stage!"
    end
  end
end

class WaterfallRequirementsAnalysis < WaterfallState
  def initialize(features)
    super
    @anomalies = Array[]
    @actions = Array[]
    @features_to = Array[]
    @next_state = WaterfallDesign
  end
  def advance_feature(feature)
    if self.anomalies.length == 0
      idx = self.features_from.index feature
      self.features_to.push Feature.new feature.name
      self.features_from.delete_at idx
      puts "Advanced #{feature.name} from Requested Features to Analysed Features"
    else
      puts "Cannot advance feature, there are unsolved anomalies!"
    end
  end
end

class WaterfallDesign < WaterfallState
  def initialize(features)
    super
    @anomalies = Array[]
    @actions = Array[]
    @features_to = Array[]
    @next_state = WaterfallImplementation
  end
  def advance_feature(feature)
    if self.anomalies.length == 0
      idx = self.features_from.index feature
      self.features_to.push Feature.new feature.name
      self.features_from.delete_at idx
      puts "Advanced #{feature.name} from Analysed Features to Designed Features"
    else
      puts "Cannot advance feature, there are unsolved anomalies!"
    end
  end
end

class WaterfallImplementation < WaterfallState
  def initialize(features)
    super
    @anomalies = Array[]
    @actions = Array[]
    @features_to = Array[]
    @next_state = WaterfallTesting
  end
  def advance_feature(feature)
    if self.anomalies.length == 0
      idx = self.features_from.index feature
      self.features_to.push Feature.new feature.name
      self.features_from.delete_at idx
      puts "Advanced #{feature.name} from Designed Features to Implemented Features"
    else
      puts "Cannot advance feature, there are unsolved anomalies!"
    end
  end
end

class WaterfallTesting < WaterfallState
  def initialize(features)
    super
    @anomalies = Array[]
    @actions = Array[]
    @features_to = Array[]
    @next_state = WaterfallMaintenance

  end
  def advance_feature(feature)
    if self.anomalies.length == 0
      idx = self.features_from.index feature
      self.features_to.push Feature.new feature.name
      self.features_from.delete_at idx
      puts "Advanced #{feature.name} from Implemented Features to Tested Features"
    else
      puts "Cannot advance feature, there are unsolved anomalies!"
    end
  end
end

class WaterfallMaintenance < WaterfallState
  def initialize(features)
    super
    @anomalies = Array[]
    @actions = Array[]
    @features_to = Array[]
    @next_state = WaterfallMaintenance
  end
  def advance_feature(feature)
      puts "This is the last stage!"
  end
end