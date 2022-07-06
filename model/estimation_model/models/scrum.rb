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
        if skill.level > best_skill.level && skill.name != "learning" && skill.name != "communication"
          best_skill = skill
        end
      end
      team_member.set_role(Role.new best_skill.name)
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
        if t1.task_type == "anomaly"
          -1
        elsif t2.task_type == "anomaly"
          1
        elsif t1.task_type == "testing"
          -1
        elsif t2.task_type == "testing"
          1
        elsif t1.task_type == "development"
          -1
        elsif t2.task_type == "development"
          1
        else
          0
        end
      end
      sorted_tasks.each do |task|
        free_team_member = free_team_members.find do |tm|
          if task.task_type == "anomaly"
            true
          else
            tm.role.name == task.task_type
          end
        end
        if free_team_member.nil?
          break
        end
        
        @actions_in_progress.push Action.new(free_team_member, task)
        
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
