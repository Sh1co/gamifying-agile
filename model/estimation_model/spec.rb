class Spec
  attr_reader :time_required,
              :required_skills,
              :difficulty,
              :task_type
  attr_accessor :is_worked_on,
                :feature,
                :knowledge

  def initialize(required_skills, task_type, time_required)
    @required_skills = required_skills
    @difficulty = required_skills.reduce(0) {|acc, skill| acc + skill.level}
    @time_required = time_required
    @task_type = task_type
    @is_worked_on = false
    @knowledge = 0
  end
end
