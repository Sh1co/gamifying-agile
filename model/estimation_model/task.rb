class Task
  attr_reader :id,
              :time_required,
              :time_spent
  attr_accessor :assignee

  def initialize(id, time_required)
    @id = id
    @time_required = time_required
    @time_spent = 0
    @assignee = nil
  end

  def increase_time_spent
    @time_spent += 1
  end

  def to_s
    "Task #{self.class} #{@id} \n"
  end
end