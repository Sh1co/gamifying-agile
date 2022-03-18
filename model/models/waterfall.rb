require_relative '../process.rb'
require_relative '../anomaly/anomaly'

class WaterfallState < DevelopmentProcessState
  attr_accessor :features_from,
                :features_to,
                :anomalies,
                :actions

  def initialize(features, task_context, anomalies_context)
    @features_from = features
    @task_context = task_context
    @anomalies_context = anomalies_context
  end

  def can_transition_state?
    self.is_a?(WaterfallMaintenance) || self.features_from.length == 0
  end
  def advance_task(feature)
    raise NotImplementedError, "#{self.class} has not implemented method '#{__method__}'"
  end
  def update
    @anomalies = @anomalies.select {|anomaly| anomaly.difficulty > 0}
    @anomalies = @anomalies + @anomalies_context.generate_anomalies(self)
  end
end

class WaterfallDevelopmentProcess < DevelopmentProcess
  def initialize(state)
    super
  end

  def advance_state
    if self.state.can_transition_state?
      puts "Transitioning from #{self.state.to_s} to #{self.state.next_state.to_s}"
      self.state = self.state.next_state.new self.state.features_to, self.state.task_context, self.state.anomalies_context
    else
      puts "Too early to go to the next stage!"
    end
  end
end

class WaterfallRequirementsAnalysis < WaterfallState
  def initialize(features, task_context, anomalies_context)
    super
    @anomalies = Array[]
    @actions = Array[]
    @features_to = Array[]
    @next_state = WaterfallDesign
  end
  def advance_task(task)
    if @task_context.can_advance_task?(task, self)
      idx = self.features_from.index task
      self.features_to.push DesignTask.new task.name
      self.features_from.delete_at idx
      self.update
      puts "Advanced #{task.name} from Requested Features to Analysed Features"
    else
      puts "Cannot advance feature!"
    end
  end
end

class WaterfallDesign < WaterfallState
  def initialize(features, task_context, anomalies_context)
    super
    @anomalies = Array[Bug.new]
    @actions = Array[]
    @features_to = Array[]
    @next_state = WaterfallImplementation
  end
  def advance_task(task)
    if @task_context.can_advance_task?(task, self)
      idx = self.features_from.index task
      self.features_to.push ImplementationTask.new task.name
      self.features_from.delete_at idx
      self.update
      puts "Advanced #{task.name} from Analysed Features to Designed Features"
    else
      puts "Cannot advance feature!"
    end
  end
end

class WaterfallImplementation < WaterfallState
  def initialize(features, task_context, anomalies_context)
    super
    @anomalies = Array[Bug.new]
    @actions = Array[ThinkReallyHard.new]
    @features_to = Array[]
    @next_state = WaterfallTesting
  end
  def advance_task(task)
    if @task_context.can_advance_task?(task, self)
      idx = self.features_from.index task
      self.features_to.push TestingTask.new task.name
      self.features_from.delete_at idx
      self.update
      puts "Advanced #{task.name} from Designed Features to Implemented Features"
    else
      puts "Cannot advance feature!"
    end
  end
end

class WaterfallTesting < WaterfallState
  def initialize(features, task_context, anomalies_context)
    super
    @anomalies = Array[]
    @actions = Array[]
    @features_to = Array[]
    @next_state = WaterfallMaintenance

  end
  def advance_task(task)
    if @task_context.can_advance_task?(task, self)
      idx = self.features_from.index task
      self.features_to.push Task.new task.name
      self.features_from.delete_at idx
      self.update
      puts "Advanced #{task.name} from Implemented Features to Tested Features"
    else
      puts "Cannot advance feature!"
    end
  end
end

class WaterfallMaintenance < WaterfallState
  def initialize(features, task_context, anomalies_context)
    super
    @anomalies = Array[]
    @actions = Array[]
    @features_to = Array[]
    @next_state = WaterfallMaintenance
  end
  def advance_task(task)
      puts "This is the last stage!"
  end
end