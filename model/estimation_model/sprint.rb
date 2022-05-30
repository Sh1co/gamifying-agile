class Sprint
  attr_reader :tasks,
              :ticks_past
  def initialize(tasks)
    @tasks = tasks
    @ticks_past = 0
  end

  def get_not_assign_tasks
    @tasks.select {|task| task.assignee.nil?}
  end

  def get_sprint_progress
    total_spent = (@tasks.map {|task| task.time_spent}).sum
    total_required = (@tasks.map {|task| task.time_required}).sum
    total_spent/total_required
  end

  def tick
    @ticks_past += 1
    print "progress before #{self.get_sprint_progress} \n"
    @tasks.each do |task|
      unless task.assignee.nil?
        task.increase_time_spent
        if task.time_spent >= task.time_required
          task.assignee.current_task = nil
          task.assignee = nil
        end
      end
    end
    print "progress after #{self.get_sprint_progress} \n"
  end
end
