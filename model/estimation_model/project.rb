require_relative './development_process'
require_relative './feature'
require_relative './models/scrum'
require_relative './Generators/FeatureGenerator'

class Project
  attr_reader :team,
              :development_process,
              :features,
              :ticks_passed,
              :statistics

  def initialize(team, stage, features)
    @development_process = DevelopmentProcess.new stage, team
    @team = team
    @features = features
    @ticks_passed = 0
    @statistics = [[], [], [], [], []]
  end

  def get_percentage_complete
    completed = @features.select {|f| f.completed == f.difficulty}.length
    completed.to_f/@features.length
  end

  def get_task_type_distribution
    analysis = @development_process.backlog.select {|t| t.task_type == "analysis"}.length
    implementation = @development_process.backlog.select {|t| t.task_type == "development"}.length
    testing = @development_process.backlog.select {|t| t.task_type == "testing"}.length
    anomaly = @development_process.backlog.select {|t| t.task_type == "anomaly"}.length
    [analysis, implementation, testing, anomaly]
  end

  def get_cumulative_flow_diagram
    analysis = @development_process.stage.actions_in_progress.select {|a| a.task_type == "analysis"}.length
    implementation = @development_process.stage.actions_in_progress.select {|a| a.task_type == "development"}.length
    testing = @development_process.stage.actions_in_progress.select {|a| a.task_type == "testing"}.length
    anomaly = @development_process.stage.actions_in_progress.select {|a| a.task_type == "anomaly"}.length
    completed = @features.select {|f| f.completed == f.difficulty}.length
    [analysis, implementation, testing, anomaly, completed]
  end

  def get_anomalies
    @features.reduce(0) { |sum, f| sum + f.anomalies.length }
  end

  def get_anomaly_impact
    a1 = @features.reduce(0) {|acc, feature| acc + feature.completed}
    a2 = @features.reduce(0) {|acc, feature| acc + [(feature.completed - feature.anomalies.reduce(0) {|sum, a| sum + a.time_required}), 0].max}
    [a1, a2]
  end

  def tick
    @development_process.tick self
    if rand < 0.1
      delete_tasks = rand 0..5
      delete_tasks.times do
        @features.delete_at(rand(@features.length))
      end
      add_tasks = rand 0..5
      max_knowledge = @features.reduce(0) {|acc, f| [acc, f.tasks[0].knowledge].max}
      @features = @features + Array.new(add_tasks) {|i| FeatureGenerator.GetFeature(max_knowledge + i)}
    end
    @ticks_passed += 1
  end

  def simulate
    until @development_process.terminated
      self.tick
      @statistics[0].push self.get_percentage_complete
      @statistics[1].push self.get_task_type_distribution
      @statistics[2].push self.get_cumulative_flow_diagram
      @statistics[3].push self.get_anomalies
      @statistics[4].push self.get_anomaly_impact
    end
    @statistics
  end
end
