class Task
  # @abstract
  attr_reader :name

  def initialize(name)
    @name = name
  end

  def to_s
    @name
  end
end

class RequirementsAnalysisTask < Task
  # @abstract
  def initialize(name)
    super
  end
end

class DesignTask < Task
  # @abstract
  def initialize(name)
    super
  end
end

class ImplementationTask < Task
  # @abstract
  def initialize(name)
    super
  end
end

class TestingTask < Task
  # @abstract
  def initialize(name)
    super
  end
end