class Feature
  attr_reader :tasks,
              :difficulty,
              :task_ind
  attr_accessor :completed

  def initialize(tasks)
    @tasks = tasks
    @difficulty = tasks.reduce(0) {|acc, task| acc + task.difficulty}
    @completed = 0
    @task_ind = 0
  end

  def get_next_task()
      if @task_ind < @tasks.length
        @task_ind += 1
        return @tasks[@task_ind-1]
      end
      return nil
  end
end
