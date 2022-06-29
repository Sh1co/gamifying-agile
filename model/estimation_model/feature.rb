class Feature
  attr_reader :tasks,
              :difficulty,
              :anomalies
  attr_accessor :completed

  def initialize(tasks)
    @tasks = tasks
    @difficulty = tasks.reduce(0) {|acc, task| acc + task.difficulty}
    @completed = 0
    @anomalies = []
  end

  def add_anomaly(anomaly)
    @anomalies.push anomaly
  end

  def delete_anomaly(anomaly)
    @anomalies = @anomalies.select {|a| a != anomaly}
  end
end
