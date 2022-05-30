require 'gruff'
require_relative './model/estimation_model/project'
require_relative './model/estimation_model/team'
require_relative './model/estimation_model/models/waterfall'
require_relative './model/estimation_model/models/scrum'
require_relative './model/estimation_model/development_process'

team = [TeamMember.new("SERGAY"), TeamMember.new("TIMUR"), TeamMember.new("SASHA")]

project_waterfall = Project.new(team, RequirementCollection.new)
project_scrum = Project.new(team, SprintPlanning.new)


# stat_w = project_waterfall.simulate
stat_s = project_scrum.simulate
g = Gruff::Line.new
g.title = 'Task completion'
# g.data :Waterfall, stat_w
g.data :Scrum, stat_s
g.write('exciting.png')