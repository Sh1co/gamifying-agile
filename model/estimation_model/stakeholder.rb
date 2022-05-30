require_relative './feature'

class Stakeholder
  def generate_features
    Array.new(100) {|i| Feature.new rand(1..5), rand(1..5), rand(1..5)}
  end
  def update_features(features)
    delete_tasks = rand 4
    features = features.delete features.sample delete_tasks
    add_tasks = rand 4
    features = features + Array.new(add_tasks) {|i| Feature.new rand(1..5), rand(1..5), rand(1..5)}
  end
end
