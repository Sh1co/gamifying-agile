require_relative './task'

class Action
  attr_reader :team_member,
              :task_class,
              :task,
              :time_spent,
              :done

  def initialize(team_member, task)
    @team_member = team_member
    team_member.is_busy = true
    @task = task
    task.is_worked_on = true
    @time_spent = 0
    @done = false
  end

  def tick(process)
    raise NotImplementedError, "#{self.class} has not implemented method '#{__method__}'"
  end
end

class RequirementAnalysisAction < Action
  def initialize(team_member, task)
    super
    @task_class = RequirementAnalysisTask
  end

  def tick(process)
    @time_spent += 1
    if @time_spent == @task.time_required
      process.backlog.delete @task
      process.backlog.push ImplementationTask.new(@task.feature)
      @task.feature.completed += @task.feature.analysis_difficulty
      @team_member.is_busy = false
      @done = true
    end
  end
end

class ImplementationAction < Action
  def initialize(team_member, task)
    super
    @task_class = ImplementationTask
  end

  def tick(process)
    @time_spent += 1
    if @time_spent == @task.time_required
      process.backlog.delete @task
      process.backlog.push TestingTask.new(@task.feature)
      @task.feature.completed += @task.feature.implementation_difficulty
      @team_member.is_busy = false
      @done = true
    end
  end
end

class TestingAction < Action
  def initialize(team_member, task)
    super
    @task_class = TestingTask
  end

  def tick(process)
    @time_spent += 1
    if @time_spent == @task.time_required
      process.backlog.delete @task
      @task.feature.completed += @task.feature.testing_difficulty
      @team_member.is_busy = false
      @done = true
    end
  end
end