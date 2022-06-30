require_relative '../spec'
require_relative '../skill'

testing_skill = Skill.new("testing", 5)
analysis_skill = Skill.new("tnalysis", 2)

testing_spec = Spec.new([testing_skill, analysis_skill], "testing", 5)

print testing_spec.difficulty ," " ,testing_spec.time_required ," " , testing_spec.task_type , "\n"