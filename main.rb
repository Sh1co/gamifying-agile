require 'gruff'
require_relative './model/estimation_model/project'
require_relative './model/estimation_model/team'
require_relative './model/estimation_model/models/waterfall'
require_relative './model/estimation_model/models/scrum'
require_relative './model/estimation_model/development_process'

team = [TeamMember.new("SERGEY"), TeamMember.new("TIMUR"), TeamMember.new("ZOOM USER")]

project_waterfall = Project.new(team, RequirementCollection.new, Array.new(100) {|i| Feature.new rand(1..3), rand(1..3), rand(1..3)})
project_scrum = Project.new(team, SprintPlanning.new([]), Array.new(100) {|i| Feature.new rand(1..3), rand(1..3), rand(1..3)})

stat_w = project_waterfall.simulate
stat_s = project_scrum.simulate
g1 = Gruff::Line.new
g1.title = 'Feature completion'
g1.data :Waterfall, stat_w[0]
g1.data :Scrum, stat_s[0]
g1.write('feature_completion.png')

g2 = Gruff::StackedArea.new
g2.title = 'Waterfall task type distribution'
g2.data :Analysis, stat_w[1].map {|t| t[0]}
g2.data :Implementation, stat_w[1].map {|t| t[1]}
g2.data :Testing, stat_w[1].map {|t| t[2]}
g2.write('waterfall_task_type.png')

g3 = Gruff::StackedArea.new
g3.title = 'Scrum task type distribution'
g3.data :Analysis, stat_s[1].map {|t| t[0]}
g3.data :Implementation, stat_s[1].map {|t| t[1]}
g3.data :Testing, stat_s[1].map {|t| t[2]}
g3.write('scrum_task_type.png')