class Spec
  attr_reader :time_required,
              :feature,
              :required_skills,
              :difficulty,
              :task_type
  attr_accessor :is_worked_on

  def initialize(feature, required_skills, task_type)
    @feature = feature
    @required_skills = required_skills
    @difficulty = required_skills.reduce(0) {|acc, skill| acc + skill.level}
    @task_type = task_type
    @is_worked_on = false
  end
end
