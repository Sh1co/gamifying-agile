require_relative './product_entity'

class CollectedRequirement < ProductEntity
  attr_reader :requirement,
              :correctness

  def initialize(requirement, correctness)
    @requirement = requirement
    @correctness = correctness
  end
end
