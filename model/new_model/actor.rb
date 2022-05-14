class Actor
  attr_reader :skills,
              :name

  def initialize(name, skills)
    @name = name
    @skills = skills
  end
end
