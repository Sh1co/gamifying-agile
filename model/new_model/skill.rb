class Skill
  attr_reader :name,
              :level

  def initialize(name, level)
    @name = name
    @level = level
  end

  def set_level(level)
    @level = level
  end

  def increase_level
    @level += 1
  end

  def decrease_level
    @level -= 1
  end
end
