class Project
  attr_reader :team,
              :current_epic,
              :epics

  def initialize(team, epics)
    @team = team
    @epics = epics
    @current_epic = @epics[0]
  end

  def get_progress
    @current_epic.current_sprint.get_sprint_progress
  end

  def assign_tasks
    free_tasks = @current_epic.current_sprint.get_not_assign_tasks
    @team.members.each do |team_member|
      unless free_tasks.length == 0
        team_member.current_task = free_tasks.pop
        team_member.current_task.assignee = team_member
      end
    end
  end

  def tick
    self.assign_tasks
    @current_epic.current_sprint.tick
  end

  def simulate
    @epics.each_with_index do |epic, i|
      print "Epic #{i} \n"
      @current_epic.sprints.each_with_index do |sprint, j|
        print "Epic #{i}. Sprint #{j}", "- - " * 15, "\n"
        while @current_epic.current_sprint.get_sprint_progress < 1
          self.tick
        end
      end
    end
  end
end
