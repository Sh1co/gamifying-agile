require_relative './task'
require_relative './skill'

class DevelopmentProcess
  attr_reader :stage,
              :backlog,
              :terminated,
              :memoized_features

  def initialize(stage)
    @stage = stage
    @terminated = false
    @backlog = []
    @memoized_features = []
  end

  def collect_requirements(project)
    @backlog = @backlog + (project.features - @memoized_features).map {|f| f.get_next_task}
    @backlog = @backlog.reject {|t| !project.features.include?(t.feature)}
    @memoized_features = project.features
  end

  def find_anomaly(anomaly)
    @backlog = @backlog + [anomaly]
  end

  def tick(project)
    if @stage.ready_to_progress?(project, self)
      next_stage = @stage.get_next_stage(project)
      if next_stage.nil?
        print "DONE!"
        @terminated = true
      else
        @stage = next_stage
      end
    end
    @stage.tick(project, self)
  end
end
