class Deliverable
  attr_reader :deliverable_type,
              :skills

  def initialize(type, skills)
    @deliverable_type = type
    @skills = skills
  end
end

class DeliverableGroup
  attr_reader :deliverables,
              :name

  def initialize(name, deliverables)
    @name = name
    @deliverables = deliverables
  end
end
