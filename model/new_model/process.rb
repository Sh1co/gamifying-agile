class Process
  attr_reader :step,
              :actors,
              :current_stage,
              :product

  def initialize(actors, product)
    @step = 1
    @actors = actors
    @product = product
  end

  def progress
    raise NotImplementedError, "#{self.class} has not implemented method '#{__method__}'"
  end

  def update
    self.progress
    @step += 1
  end
end
