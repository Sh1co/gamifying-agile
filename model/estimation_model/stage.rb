class Stage
  attr_reader :actions,
              :ticks_passed,
              :actions_in_progress

  def initialize
    @ticks_passed = 0
    @actions_in_progress = []
  end

  def tick(project, process)
    raise NotImplementedError, "#{self.class} has not implemented method '#{__method__}'"
  end

  def ready_to_progress?(project, process)
    raise NotImplementedError, "#{self.class} has not implemented method '#{__method__}'"
  end

  def get_next_stage(project)
    raise NotImplementedError, "#{self.class} has not implemented method '#{__method__}'"
  end

  def to_s
    "#{self.class}"
  end
end
