require_relative '../task/task'

class Anomaly
  # @abstract
  attr_accessor :difficulty
  attr_reader :blocking_tasks
end

class Bug < Anomaly
  def initialize
    @difficulty = 4
    @blocking_tasks = Array[ImplementationTask]
  end
end
