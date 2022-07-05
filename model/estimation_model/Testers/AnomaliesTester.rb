require_relative '../action'
require_relative '../team'
require_relative '../spec'
require_relative '../skill'
require_relative '../feature'
require_relative '../development_process'
require_relative '../stage'
require_relative '../anomaly'

analysis_task = Spec.new([Skill.new("analysis", 10)], "analysis", 1)
testing_task = Spec.new([Skill.new("testing", 7)], "testing", 1)

sherif = TeamMember.new("TESTER", [Skill.new('testing', 11), Skill.new('development', 11)])

test_feature = Feature.new([analysis_task, testing_task])

test_process = DevelopmentProcess.new(Stage.new)
test_process.backlog.push test_feature.get_next_task

while !test_process.backlog.empty? do
    nxt_task = test_process.backlog.pop
    print nxt_task.task_type," ", nxt_task.feature.completed, "\n"
    test_action = Action.new(sherif, nxt_task)

    while !test_action.done do
        test_action.tick(test_process)
        print "tick" , "\n"
    end
    print "done", "\n"
end