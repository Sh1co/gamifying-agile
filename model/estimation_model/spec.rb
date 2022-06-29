class Spec
  attr_reader :time_required,
              :feature,
              :required_skills,
              :difficulty
  attr_accessor :is_worked_on

  def initialize(feature, required_skills)
    @feature = feature
    @required_skills = required_skills
    @difficulty = required_skills.reduce(0) {|acc, skill| acc + skill.level}
    @is_worked_on = false
  end
end
