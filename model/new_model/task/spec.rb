class Specification
  attr_reader :name,
              :complexity

  def initialize(name, complexity)
    @name = name
    @complexity = complexity
  end
end

class Task < Specification
  attr_reader :story,
              :deliverable_group,
              :prerequisites

  def initialize(name,
                 complexity,
                 story,
                 deliverable_group,
                 prerequisites
  )
    super(name, complexity)
    @story = story
    @deliverable_group = deliverable_group
    @prerequisites = prerequisites
  end
end

class Refactor < Specification

end

class Anomaly < Refactor

end
