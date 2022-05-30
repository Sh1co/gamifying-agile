require_relative '../process.rb'
require_relative '../anomaly/anomaly'
require_relative '../task'


class ScrumDevelopmentProcess < Project
  def initialize(state)
    super
  end

  def switch_state(state)
    if self.state.can_transition_state? state
      puts "Transitioning from #{self.state.to_s} to #{state.to_s}"
      self.state = state.new self.state.current_tasks, self.state.task_context, self.state.anomalies_context
    else
      puts "Too early to go to the next stage!"
    end
  end
end

class ScrumState < DevelopmentProcessState
    attr_accessor :anomalies,
                  :actions
  
    def initialize(backlog, anomalies_context, sprint_length)
      @backlog = backlog
      @anomalies_context = anomalies_context
      @sprint_length = sprint_length
    end
  
    def advance_task(feature)
      raise NotImplementedError, "#{self.class} has not implemented method '#{__method__}'"
    end
    def update
      @anomalies = @anomalies.select {|anomaly| anomaly.difficulty > 0}
      @anomalies = @anomalies + @anomalies_context.generate_anomalies(self)
    end
end

class ScrumSprintPlanning < ScrumState

    def initialize(backlog, anomalies_context, sprint_length, developers)
        super
        @tasks_added = false
        @developers = @developers
        @sprint_tasks = Array[]
        @next_state = ScrumDaily
    end
    
    def can_transition_state?(state)
        @tasks_added
    end

    def update()
        choose_tasks_for_sprint() if !@tasks_added
    end

    def choose_tasks_for_sprint()
        # possible upgrade: choose tasks based on devs skills
        for developer in @developers
          break if @backlog.empty?
          task = @backlog.first()
          task.assignee = developer
          developer.busy = true
          @backlog.drop!(1)
          @sprint_tasks.add(task)
        end
        raise NotImplementedError, "#{self.class} has not implemented method '#{__method__}'"
    end

end

class ScrumDaily < ScrumState

    def initialize(backlog, anomalies_context, sprint_length, sprint_tasks)
        super
        @current_sprint_days = 0
        @sprint_tasks = sprint_tasks
        @next_state = ScrumReview
    end

    def can_transition_state?(state)
        (@current_sprint_days >= @sprint_length)
    end

    def update()
        progress_tasks()
        finish_sprint_day()
    end

    def finish_sprint_day()
        @current_sprint_days+=1
    end

    def progress_tasks()
        for task in @sprint_tasks
            task.update()
            next if task.progress > 0
            # TODO: add tasks generated from completetion to backlog
            task.assignee.busy = false
            @sprint_tasks.delete!(task)
        end
        raise NotImplementedError, "#{self.class} has not implemented method '#{__method__}'"
    end

end

class ScrumReview < ScrumState

    def initialize(backlog, anomalies_context, sprint_length, sprint_tasks)
        super
        @tasks_sent_back = false
        @sprint_tasks = sprint_tasks
        @next_state = ScrumSprintPlanning
    end

    def can_transition_state?(state)
        @tasks_sent_back
    end

    def update()
        send_sprint_tasks_to_backlog() if !@tasks_sent_back
    end

    def send_sprint_tasks_to_backlog()
        for task in @sprint_tasks
            @backlog.unshift!(task)
        end
        @tasks_sent_back = true
    end
end 

class ScrumDeveloper > TeamMember
  attr_accessor: busy
end

