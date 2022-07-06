require_relative '../spec'
require_relative '../skill'
require_relative '../feature'

class FeatureGenerator
    def self.GetFeature(knowledge_needed)
        analysis_task = Spec.new([Skill.new("analysis", rand(3..7))], "analysis", rand(3..7))
        development_task = Spec.new([Skill.new("development", rand(3..7))], "development", rand(3..7))
        testing_task = Spec.new([Skill.new("testing", rand(3..7))], "testing", rand(3..7))

        analysis_task.knowledge = knowledge_needed
        development_task.knowledge = knowledge_needed+1
        testing_task.knowledge = knowledge_needed+2

        generated_feature = Feature.new([analysis_task, development_task, testing_task])

        return generated_feature
    end
end