class TeamMember
  attr_reader :name
  attr_accessor :is_busy

  def initialize(name)
    @name = name
    @is_busy = false
  end
end

class Team
  attr_reader :members

  def initialize(members)
    @members = members
  end
end