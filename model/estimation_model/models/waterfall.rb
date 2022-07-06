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
    RequirementAnalysis.new project.team
  end
end

class RequirementAnalysis < Stage
  def initialize(team)
    super()
    #assign roles
    team.each do |team_member|
      team_member.set_role(Role.new "analysis")
    end
  end

  def tick(project, process)
    @ticks_passed += 1
    @actions_in_progress.each {|a| a.tick(process)}
    @actions_in_progress = @actions_in_progress.select {|a| !a.done}
    free_team_members =  project.team.select {|tm| !tm.is_busy}
    if free_team_members.length > 0
      process.backlog.select {|t| t.task_type == "analysis" && !t.is_worked_on}.each do |task|
        free_team_member = free_team_members.pop
        if free_team_member.nil?
          break
        end
        @actions_in_progress.push Action.new(free_team_member, task)
      end
    end
  end

  def ready_to_progress?(project, process)
    process.backlog.reduce {|acc, task| acc && task.task_type == "development"}
  end

  def get_next_stage(project)
    Implementation.new project.team
  end
end

class Implementation < Stage
  def initialize(team)
    super()
    #assign roles
    team.each do |team_member|
      team_member.set_role(Role.new "development")
    end
  end

  def tick(project, process)
    @ticks_passed += 1
    @actions_in_progress.each {|a| a.tick(process)}
    @actions_in_progress = @actions_in_progress.select {|a| !a.done}
    free_team_members =  project.team.select {|tm| !tm.is_busy}
    if free_team_members.length > 0
      process.backlog.select {|t| t.task_type == "development" && !t.is_worked_on}.each do |task|
        free_team_member = free_team_members.pop
        if free_team_member.nil?
          break
        end
        @actions_in_progress.push Action.new free_team_member, task
      end
    end
  end

  def ready_to_progress?(project, process)
    process.backlog.reduce {|acc, task| acc && task.task_type == "testing"}
  end

  def get_next_stage(project)
    Testing.new project.team
  end
end

class Testing < Stage
  def initialize(team)
    super()
    #assign roles
    team.each do |team_member|
      team_member.set_role(Role.new "testing")
    end
  end

  def ready_to_progress?(project, process)
    process.backlog.select {|t| t.task_type == "testing" || t.task_type == "anomaly"}.length == 0
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
      process.backlog.select {|t| (t.task_type == "testing" || t.task_type == "anomaly") && !t.is_worked_on}.each do |task|
        free_team_member = free_team_members.pop
        if free_team_member.nil?
          break
        end
        @actions_in_progress.push Action.new free_team_member, task
      end
    end
  end
end
