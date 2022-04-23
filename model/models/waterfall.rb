require_relative '../process.rb'
require_relative '../anomaly/anomaly'

class WaterfallState < DevelopmentProcessState
  attr_accessor :anomalies,
                :actions

  def initialize(features, anomalies_context)
    @current_tasks = features
    @anomalies_context = anomalies_context
  end

  def advance_task(feature)
    raise NotImplementedError, "#{self.class} has not implemented method '#{__method__}'"
  end
  def update
    @anomalies = @anomalies.select {|anomaly| anomaly.difficulty > 0}
    @anomalies = @anomalies + @anomalies_context.generate_anomalies(self)
  end
end

# class WaterfallDevelopmentProcess < DevelopmentProcess
#   def initialize(state)
#     super
#   end
#
#   def switch_state(state)
#     if self.state.can_transition_state? state
#       puts "Transitioning from #{self.state.to_s} to #{state.to_s}"
#       self.state = state.new self.state.current_tasks, self.state.task_context, self.state.anomalies_context
#     else
#       puts "Too early to go to the next stage!"
#     end
#   end
# end

class WaterfallRequirementsAnalysis < WaterfallState
  def initialize(features, task_context, anomalies_context)
    super
    @anomalies = Array[]
    @actions = Array[]
    @features_to = Array[]
    @next_states = Array[WaterfallDesign]
  end

  def advance_task(task)
    if @task_context.can_advance_task?(task, self)
      idx = self.current_tasks.index task
      self.current_tasks.push DesignTask.new task.name
      self.current_tasks.delete_at idx
      self.update
      puts "Advanced #{task.name} from Requested Features to Analysed Features"
    else
      puts "Cannot advance feature!"
    end
  end

  def can_transition_state?(state)
    !self.current_tasks.reduce(false) {|acc, el| acc or el.is_a?(RequirementsAnalysisTask)}
  end
end

class WaterfallDesign < WaterfallState
  def initialize(features, task_context, anomalies_context)
    super
    @anomalies = Array[Bug.new]
    @actions = Array[]
    @features_to = Array[]
    @next_states = Array[WaterfallImplementation]
  end

  def advance_task(task)
    if @task_context.can_advance_task?(task, self)
      idx = self.current_tasks.index task
      self.current_tasks.push ImplementationTask.new task.name
      self.current_tasks.delete_at idx
      self.update
      puts "Advanced #{task.name} from Analysed Features to Designed Features"
    else
      puts "Cannot advance feature!"
    end
  end

  def can_transition_state?(state)
    !self.current_tasks.reduce(false) {|acc, el| acc or el.is_a?(DesignTask)}
  end
end

class WaterfallImplementation < WaterfallState
  def initialize(features, task_context, anomalies_context)
    super
    @anomalies = Array[Bug.new]
    @actions = Array[ThinkReallyHard.new]
    @features_to = Array[]
    @next_states = Array[WaterfallTesting]
  end

  def advance_task(task)
    if @task_context.can_advance_task?(task, self)
      idx = self.current_tasks.index task
      self.current_tasks.push TestingTask.new task.name
      self.current_tasks.delete_at idx
      self.update
      puts "Advanced #{task.name} from Designed Features to Implemented Features"
    else
      puts "Cannot advance feature!"
    end
  end

  def can_transition_state?(state)
    !self.current_tasks.reduce(false) {|acc, el| acc or el.is_a?(ImplementationTask)}
  end
end

class WaterfallTesting < WaterfallState
  def initialize(features, task_context, anomalies_context)
    super
    @anomalies = Array[]
    @actions = Array[]
    @features_to = Array[]
    @next_states = Array[WaterfallMaintenance]

  end

  def advance_task(task)
    if @task_context.can_advance_task?(task, self)
      idx = self.current_tasks.index task
      self.current_tasks.push Task.new task.name
      self.current_tasks.delete_at idx
      self.update
      puts "Advanced #{task.name} from Implemented Features to Tested Features"
    else
      puts "Cannot advance feature!"
    end
  end

  def can_transition_state?(state)
    !self.current_tasks.reduce(false) {|acc, el| acc or el.is_a?(TestingTask)}
  end
end

class WaterfallMaintenance < WaterfallState
  def initialize(features, task_context, anomalies_context)
    super
    @anomalies = Array[]
    @actions = Array[]
    @features_to = Array[]
    @next_states = Array[WaterfallMaintenance]
  end

  def advance_task(task)
      puts "This is the last stage!"
  end

  def can_transition_state?(state)
    true
  end
end