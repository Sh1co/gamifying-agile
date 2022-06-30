require_relative '../stage'
require_relative '../action'
require_relative '../task'
require_relative '../anomaly'
require_relative '../role'

class SprintPlanning < Stage
  def initialize(actions_in_progress, team)
    super()
    team.each {|team_member| team_member.reset_role}
    @actions_in_progress = actions_in_progress
  end

  def tick(project, process)
    @ticks_passed += 1
    process.collect_requirements(project)
  end

  def ready_to_progress?(project, process)
    @ticks_passed == 1
  end

  def get_next_stage(project)
    SprintExecution.new @actions_in_progress, project.team
  end
end

class SprintExecution < Stage
  def initialize(actions_in_progress, team)
    super()
    #assign roles
    team.each do |team_member|
      best_skill = team_member.skills[0]
      team_member.skills.each do |skill|
        if skill.level > best_skill.level
          best_skill = skill
        end
      end

      #TODO needs to change
      if best_skill.name == "testing"
        team_member.set_role(Role.new "tester")
      elsif best_skill.name == "development"
        team_member.set_role(Role.new "developer")
      elsif best_skill.name == "analysis"
        team_member.set_role(Role.new "analytic")
      end
    end
    @actions_in_progress = actions_in_progress
  end

  def tick(project, process)
    @ticks_passed += 1
    @actions_in_progress.each {|a| a.tick(process)}
    @actions_in_progress = @actions_in_progress.select {|a| !a.done}
    free_team_members = project.team.select {|tm| !tm.is_busy}
    if free_team_members.length > 0 && !self.ready_to_progress?(project, process)
      sorted_tasks = process.backlog.select {|t| !t.is_worked_on}.sort! do |t1, t2|
        if t1.is_a? Anomaly
          -1
        elsif t2.is_a? Anomaly
          1
        elsif t1.is_a? TestingTask
          -1
        elsif t2.is_a? TestingTask
          1
        elsif t1.is_a? ImplementationTask
          -1
        elsif t2.is_a? ImplementationTask
          1
        else
          0
        end
      end
      sorted_tasks.each do |task|
        free_team_member = free_team_members.find do |tm|
          if task.is_a? Anomaly
            true
          elsif task.is_a?(RequirementAnalysisTask)
            tm.role.name == "analytic"
          elsif task.is_a?(ImplementationTask)
            tm.role.name == "developer"
          elsif task.is_a?(TestingTask)
            tm.role.name == "tester"
          end
        end
        if free_team_member.nil?
          break
        end
        if task.is_a? Anomaly
          @actions_in_progress.push AnomalyFixingAction.new(free_team_member, task)
        elsif task.is_a?(RequirementAnalysisTask) && free_team_member.role.name == "analytic"
          @actions_in_progress.push RequirementAnalysisAction.new(free_team_member, task)
        elsif task.is_a?(ImplementationTask) && free_team_member.role.name == "developer"
          @actions_in_progress.push ImplementationAction.new(free_team_member, task)
        elsif task.is_a?(TestingTask) && free_team_member.role.name == "tester"
          @actions_in_progress.push TestingAction.new(free_team_member, task)
        end
      end
    end
  end

  def ready_to_progress?(project, process)
    @ticks_passed == 20
  end

  def get_next_stage(project)
    #TODO Make the number of ticks changable in initialization not hard coded
    if project.ticks_passed >= 300
      nil
    else
      SprintPlanning.new @actions_in_progress, project.team
    end
  end
end
