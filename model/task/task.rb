require_relative '../product_entity'

class Spec
  attr_reader :product_entity,
              :assignee,
              :progress,
              :correctness

  def initialize(product_entity, assignee)
    @product_entity = product_entity
    @assignee = assignee

    if @product_entity.class === Requirement
      @progress = @product_entity.complexity
    elsif  @product_entity.class === CollectedRequirement
      @progress = @product_entity.requirement.complexity
    elsif @product_entity.class === DesignedTask
      @progress = @product_entity.software_component.complexity
    elsif @product_entity.class === CompletedTask
      @progress = @product_entity.software_component.complexity
    end
    @correctness = 0
  end

  def update
    @progress -= 1
  end

  def generate_next_entity
    if @product_entity.class === Requirement
      CollectedRequirement.new @product_entity, @correctness
    elsif  @product_entity.class === CollectedRequirement
      #TODO: understand how we can spread it
    elsif @product_entity.class === DesignedTask
      CompletedTask.new @product_entity, @correctness
    elsif @product_entity.class === CompletedTask
      #TODO: understand how we can collect it back it
    end
  end
end
