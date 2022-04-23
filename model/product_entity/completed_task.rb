class CompletedTask
  attr_reader :task,
              :correctness

  def initialize(task, correctness)
    @task = task
    @correctness = correctness
  end
end
