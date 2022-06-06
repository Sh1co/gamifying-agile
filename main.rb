require 'gruff'
require_relative './model/estimation_model/project'
require_relative './model/estimation_model/team'
require_relative './model/estimation_model/models/waterfall'
require_relative './model/estimation_model/models/scrum'
require_relative './model/estimation_model/development_process'

team = [
  TeamMember.new("SERGEY"),
  TeamMember.new("TIMUR"),
  TeamMember.new("ZOOM USER"),
  TeamMember.new("ZOOM"),
  TeamMember.new("USER"),
  TeamMember.new("AAA"),
  TeamMember.new("QWERе"),
  TeamMember.new("1"),
  TeamMember.new("2"),
  TeamMember.new("2 USER"),
  TeamMember.new("3"),
  TeamMember.new("4"),
  TeamMember.new("5"),
  TeamMember.new("6")
]

project_waterfall = Project.new(team, RequirementCollection.new, Array.new(200) {|i| Feature.new rand(1..5), rand(1..5), rand(1..5)})
project_scrum = Project.new(team, SprintPlanning.new([]), Array.new(200) {|i| Feature.new rand(1..5), rand(1..5), rand(1..5)})

stat_w = project_waterfall.simulate
stat_s = project_scrum.simulate
g1 = Gruff::Line.new
g1.data :Waterfall, stat_w[0]
g1.data :Scrum, stat_s[0]
g1.write('feature_completion.png')

g2 = Gruff::StackedArea.new
g2.data :Analysis, stat_w[1].map {|t| t[0]}
g2.data :Implementation, stat_w[1].map {|t| t[1]}
g2.data :Testing, stat_w[1].map {|t| t[2]}
g2.write('waterfall_task_type.png')

g3 = Gruff::StackedArea.new
g3.data :Analysis, stat_s[1].map {|t| t[0]}
g3.data :Implementation, stat_s[1].map {|t| t[1]}
g3.data :Testing, stat_s[1].map {|t| t[2]}
g3.write('scrum_task_type.png')

g4 = Gruff::StackedArea.new
g4.data :Analysing, stat_w[2].map {|t| t[0]}
g4.data :Implementation, stat_w[2].map {|t| t[1]}
g4.data :Testing, stat_w[2].map {|t| t[2]}
g4.data :Completed, stat_w[2].map {|t| t[3]}
g4.write('waterfall_cfd.png')

g5 = Gruff::StackedArea.new
g5.data :Analysing, stat_s[2].slice(0, 100).map {|t| t[0]}
g5.data :Implementation, stat_s[2].slice(0, 100).map {|t| t[1]}
g5.data :Testing, stat_s[2].slice(0, 100).map {|t| t[2]}
g5.data :Completed, stat_s[2].slice(0, 100).map {|t| t[3]}
g5.write('scrum_cfd.png')