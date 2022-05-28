class Epic
  attr_reader :sprints,
              :current_sprint

  def initialize(sprints)
    @sprints = sprints
    @current_sprint = @sprints[0]
  end
end