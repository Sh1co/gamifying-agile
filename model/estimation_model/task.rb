require_relative 'spec'
class Task < Spec
end
############  D  E  A  D  #############
class RequirementAnalysisTask < Task
  def initialize(feature, required_skills)
    super
    @time_required = feature.analysis_difficulty
  end
end

class ImplementationTask < Task
  def initialize(feature, required_skills)
    super
    @time_required = feature.implementation_difficulty
  end
end

class TestingTask < Task
  def initialize(feature, required_skills)
    super
    @time_required = feature.testing_difficulty
  end
end
3