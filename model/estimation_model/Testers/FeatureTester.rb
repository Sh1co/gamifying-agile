require_relative '../spec'
require_relative '../skill'
require_relative '../feature'

analysis_task = Spec.new([Skill.new("analysis", 8)], "analysis", 7)
development_task = Spec.new([Skill.new("development", 6)], "development", 4)
testing_task = Spec.new([Skill.new("testing", 7)], "testing", 5)

test_feature = Feature.new([analysis_task, development_task, testing_task])

nxt_task = test_feature.get_next_task

while !nxt_task.nil? do
    print nxt_task.task_type," ", nxt_task.feature.difficulty, "\n"

    nxt_task = test_feature.get_next_task
end