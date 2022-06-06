class Skill
  attr_reader :name,
              :level

  def initialize(name, level)
    @name = name
    @level = level
  end
end
