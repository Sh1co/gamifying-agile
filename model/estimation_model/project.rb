require_relative './development_process'
require_relative './feature'

class Project
  attr_reader :team,
              :development_process,
              :features,
              :ticks_passed,
              :statistics

  def initialize(team, stage)
    @development_process = DevelopmentProcess.new stage
    @team = team
    @features = Array.new(100) {|i| Feature.new 1, 1, 1}
    @ticks_passed = 0
    @statistics = []
  end

  def get_percentage_complete
    completed = @features.select {|f| f.completed == f.difficulty}.length
    completed.to_f/@features.length
  end

  def tick
    @development_process.tick self
    if rand < 0.1
      delete_tasks = rand 0..1
      delete_tasks.times do
        @features.delete_at(rand(@features.length))
      end
      add_tasks = rand 0..2
      @features = @features + Array.new(add_tasks) {|i| Feature.new rand(1..5), rand(1..5), rand(1..5)}
    end
    @ticks_passed += 1
  end

  def simulate
    until @development_process.terminated
      self.tick
      # print("#{@ticks_passed} ticks passed \n")
      # print "B #{@development_process.backlog.length} M #{@development_process.memoized_features.length} F #{@features.length} \n"
      # print self.get_percentage_complete, "\n"
      @statistics.push self.get_percentage_complete
    end
    @statistics
  end
end
