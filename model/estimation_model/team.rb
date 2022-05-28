class TeamMember
  attr_reader :name
  attr_accessor :current_task

  def initialize(name)
    @name = name
    @current_task = nil
  end
end

class Team
  attr_reader :members

  def initialize(members)
    @members = members
  end
end