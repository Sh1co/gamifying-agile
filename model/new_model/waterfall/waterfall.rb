require_relative '../process'
require_relative '../stage'

class WaterfallProcess < Process
  def initialize(actors)
    super
    @current_stage = RequirementsCollectionStage
  end

  def progress

  end
end

class RequirementsCollectionStage < LeafStage
  def initialize
    super
    @next_stage = RequirementsAnalysisStage
  end
end

class RequirementsAnalysisStage < LeafStage
  def initialize
    super
    @next_stage = ImplementationStage
  end
end

class ImplementationStage < LeafStage
  def initialize
    super
    @next_stage = TestingStage
  end
end

class TestingStage < LeafStage
  def initialize
    super
    @next_stage = MaintenanceStage
  end
end

class MaintenanceStage < LeafStage
  def initialize
    super
    @next_stage = nil
  end
end
