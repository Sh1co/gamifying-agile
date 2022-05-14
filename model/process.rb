require_relative 'actions.rb'
require_relative 'anomaly/anomaly.rb'
require_relative 'task/task.rb'

class DevelopmentProcessState
  attr_accessor :next_states,
                :anomalies,
                :actions
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
  attr_accessor :state
  attr_reader :step,
              :developers,
              :current_tasks,
              :product_state

  def initialize(state, developers, requirements)
    @state = state
    @step = 0
    @developers = developers
    @current_tasks = []
    @product_state = requirements
  end

  def switch_state(state)
    raise NotImplementedError, "#{self.class} has not implemented method '#{__method__}'"
  end

  def assign_task(product_entity, developer)
    is_busy = @current_tasks.find {|task| task.assignee == developer}
    if is_busy.nil?
      @current_tasks.push Spec.new product_entity, developer
    end
  end

  def advance_step
    @state.anomalies_context.generate_anomalies @current_tasks, @state.anomalies
    @current_tasks.each do |task|
      unless @state.anomalies.reduce {|anomaly| anomaly.class == TaskAnomaly && anomaly.blocking_task == task.product_entity.class}
        task.update
        if task.progress == 0
          @product_state = @product_state - [task.product_entity]
          @product_state.push task.generate_next_entity
        end
      end
    end
    @step += 1
  end
end
