require_relative 'spec'

class Anomaly < Spec
  attr_accessor :found

  def initialize(required_skills, task_type, time_required, feature)
    super(required_skills, task_type, time_required)
    @found = false
    @feature = feature
  end
end
