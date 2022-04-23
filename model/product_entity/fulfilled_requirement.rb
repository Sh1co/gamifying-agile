class FulfilledRequirement
  attr_reader :requirement,
              :correctness

  def initialize(requirement, correctness)
    @requirement = requirement
    @correctness = correctness
  end
end
