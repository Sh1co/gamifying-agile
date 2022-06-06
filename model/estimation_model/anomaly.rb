require_relative 'spec'

class Anomaly < Spec
  def initialize(feature, required_skills)
    super
    @time_required = rand(1..2)
  end
end
