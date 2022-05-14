class Product
  attr_reader :deliverables,
              :tasks

  def initialize(deliverables, tasks)
    @deliverables = deliverables
    @tasks = tasks
  end
end
