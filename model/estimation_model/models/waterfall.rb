require_relative '../stage'
require_relative '../action'
require_relative '../task'

class RequirementCollection < Stage
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
    RequirementAnalysis.new
  end
end

class RequirementAnalysis < Stage
  def initialize
    super
  end

  def tick(project, process)
    @ticks_passed += 1
    @actions_in_progress.each {|a| a.tick(process)}
    @actions_in_progress = @actions_in_progress.select {|a| !a.done}
    free_team_members =  project.team.select {|tm| !tm.is_busy}
    if free_team_members.length > 0
      process.backlog.select {|t| t.is_a?(RequirementAnalysisTask) && !t.is_worked_on}.each do |task|
        free_team_member = free_team_members.pop
        if free_team_member.nil?
          break
        end
        @actions_in_progress.push RequirementAnalysisAction.new(free_team_member, task)
      end
    end
  end

  def ready_to_progress?(project, process)
    process.backlog.reduce {|acc, task| acc && task.class == ImplementationTask}
  end

  def get_next_stage(project)
    Implementation.new
  end
end

class Implementation < Stage
  def initialize
    super
  end

  def tick(project, process)
    @ticks_passed += 1
    @actions_in_progress.each {|a| a.tick(process)}
    @actions_in_progress = @actions_in_progress.select {|a| !a.done}
    free_team_members =  project.team.select {|tm| !tm.is_busy}
    if free_team_members.length > 0
      process.backlog.select {|t| t.is_a?(ImplementationTask) && !t.is_worked_on}.each do |task|
        free_team_member = free_team_members.pop
        if free_team_member.nil?
          break
        end
        @actions_in_progress.push ImplementationAction.new free_team_member, task
      end
    end
  end

  def ready_to_progress?(project, process)
    process.backlog.reduce {|acc, task| acc && task.class == TestingTask}
  end

  def get_next_stage(project)
    Testing.new
  end
end

class Testing < Stage
  def initialize
    super
  end

  def ready_to_progress?(project, process)
    process.backlog.select {|t| t.is_a? TestingTask}.length == 0
  end

  def get_next_stage(project)
    nil
  end

  def tick(project, process)
    @ticks_passed += 1
    @actions_in_progress.each {|a| a.tick(process)}
    @actions_in_progress = @actions_in_progress.select {|a| !a.done}
    free_team_members =  project.team.select {|tm| !tm.is_busy}
    if free_team_members.length > 0
      process.backlog.select {|t| t.is_a?(TestingTask) && !t.is_worked_on}.each do |task|
        free_team_member = free_team_members.pop
        if free_team_member.nil?
          break
        end
        @actions_in_progress.push TestingAction.new free_team_member, task
      end
    end
  end
end