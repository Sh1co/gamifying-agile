require_relative './model/estimation_model/project'
require_relative './model/estimation_model/task'
require_relative './model/estimation_model/sprint'
require_relative './model/estimation_model/epic'
require_relative './model/estimation_model/team'

tasks = [Task.new("Fronted", 4), Task.new("Backend", 3)]
sprint = Sprint.new tasks
epic = Epic.new [sprint]

dev1 = TeamMember.new "Ivan"
dev2 = TeamMember.new "Sergay"

team = Team.new [dev1, dev2]

project = Project.new team, [epic]

project.simulate