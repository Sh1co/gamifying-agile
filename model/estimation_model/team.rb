class TeamMember
  attr_reader :name, :skills, :role
  attr_accessor :is_busy

  def initialize(name, skills)
    @name = name
    @skills = skills
    @is_busy = false
  end

  def set_role(role)
    @role = role
  end

  def reset_role
    @role = nil
  end
end

class Team
  attr_reader :members

  def initialize(members)
    @members = members
  end
end