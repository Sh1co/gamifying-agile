class Stage
  attr_reader :next_stage

  def get_leaf_stage
    raise NotImplementedError, "#{self.class} has not implemented method '#{__method__}'"
  end
end

class CompositeStage < Stage
  attr_reader :current_substage

  def get_leaf_stage
    @current_substage.get_leaf_stage
  end
end

class LeafStage < Stage
  attr_reader :actions
  def initialize
    super
  end

  def get_leaf_stage
    self
  end
end

