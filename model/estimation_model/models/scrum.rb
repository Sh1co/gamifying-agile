require_relative '../stage'
require_relative '../action'
require_relative '../task'

class SprintPlanning < Stage
  def initialize
    super
  end

  def tick(project, process)
    @ticks_passed += 1
    process.collect_requirements(project)
  end

  def ready_to_progress?(project, process)
    @ticks_passed == 1
  end

  def get_next_stage(project)
    SprintExecution.new
  end
end

class SprintExecution < Stage
  def initialize
    super
  end

  # sort_by do |t1, t2|
  #   if t1.is_a? TestingTask
  #     1
  #   elsif t2.is_a? TestingTask
  #     -1
  #   elsif t1.is_a? ImplementationTask
  #     1
  #   elsif t2.is_a? ImplementationTask
  #     -1
  #   else
  #     0
  #   end
  # end.


  def tick(project, process)
    @ticks_passed += 1
    @actions_in_progress.each {|a| a.tick(process)}
    @actions_in_progress = @actions_in_progress.select {|a| !a.done}
    free_team_members = project.team.select {|tm| !tm.is_busy}
    if free_team_members.length > 0
      process.backlog.select {|t| !t.is_worked_on}.each do |task|
        free_team_member = free_team_members.pop
        if free_team_member.nil?
          break
        end
        if task.is_a? RequirementAnalysisTask
          @actions_in_progress.push RequirementAnalysisAction.new(free_team_member, task)
        elsif task.is_a? ImplementationTask
          @actions_in_progress.push ImplementationAction.new(free_team_member, task)
        elsif task.is_a? TestingTask
          @actions_in_progress.push TestingAction.new(free_team_member, task)
        end
      end
    end
  end

  def ready_to_progress?(project, process)
    @ticks_passed == 20
  end

  def get_next_stage(project)
    if project.ticks_passed >= 10000
      nil
    else
      SprintExecution.new
    end
  end
end
