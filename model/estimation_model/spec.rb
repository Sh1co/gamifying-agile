class Spec
  attr_reader :time_required,
              :feature,
              :required_skills
  attr_accessor :is_worked_on

  def initialize(feature, required_skills)
    @feature = feature
    @required_skills = required_skills
    @is_worked_on = false
  end
end
