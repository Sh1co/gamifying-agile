require_relative './task'

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
    @backlog = @backlog + (project.features - @memoized_features).map {|f| RequirementAnalysisTask.new f}
    @backlog = @backlog.reject {|t| !project.features.include?(t.feature)}
    @memoized_features = project.features
  end

  def tick(project)
    @stage.tick(project, self)
    # print "#{project.features.length} #{@backlog.length} \n"
    if @stage.ready_to_progress?(project, self)
      next_stage = @stage.get_next_stage(project)
      # print "PROGRESSING TO STAGE #{next_stage.to_s} \n"
      if next_stage.nil?
        print "DONE!"
        @terminated = true
      else
        @stage = next_stage
      end
    end
  end
end
