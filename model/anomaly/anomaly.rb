require_relative '../task/task'

class Anomaly
  attr_reader :difficulty

  def initialize(difficulty)
    @difficulty = difficulty
  end
end

class TaskAnomaly < Anomaly
  attr_reader :blocking_task

  def initialize(difficulty, blocking_task)
    super(difficulty)
    @blocking_task = blocking_task
  end
end

class TeamMemberAnomaly < Anomaly
  attr_reader :blocking_team_member

  def initialize(difficulty, team_member)
    super(difficulty)
    @blocking_team_member = team_member
  end
end

class ActionAnomaly < Anomaly
  attr_reader :blocking_action

  def initialize(difficulty, blocking_action)
    super(difficulty)
    @blocking_action = blocking_action
  end
end