class Task
  attr_reader :time_required,
              :feature
  attr_accessor :is_worked_on

  def initialize(feature)
    @feature = feature
    @is_worked_on = false
  end
end

class RequirementAnalysisTask < Task
  def initialize(feature)
    super
    @time_required = feature.analysis_difficulty
  end
end

class ImplementationTask < Task
  def initialize(feature)
    super
    @time_required = feature.implementation_difficulty
  end
end

class TestingTask < Task
  def initialize(feature)
    super
    @time_required = feature.testing_difficulty
  end
end