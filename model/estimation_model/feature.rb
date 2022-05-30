class Feature
  attr_reader :analysis_difficulty,
              :implementation_difficulty,
              :testing_difficulty,
              :difficulty
  attr_accessor :completed

  def initialize(analysis_difficulty, implementation_difficulty, testing_difficulty)
    @difficulty = analysis_difficulty + implementation_difficulty + testing_difficulty
    @analysis_difficulty = analysis_difficulty
    @implementation_difficulty = implementation_difficulty
    @testing_difficulty = testing_difficulty
    @completed = 0
  end
end
