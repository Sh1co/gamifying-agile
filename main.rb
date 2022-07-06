require 'gruff'
require_relative './model/estimation_model/project'
require_relative './model/estimation_model/team'
require_relative './model/estimation_model/models/waterfall'
require_relative './model/estimation_model/models/scrum'
require_relative './model/estimation_model/development_process'
require_relative './model/estimation_model/Generators/FeatureGenerator'

team1 = [
  TeamMember.new("TESTER", [Skill.new('testing', 9), Skill.new('development', 3), Skill.new('analysis', 1), Skill.new('communication', 2), Skill.new('learning', 3)]),
  TeamMember.new("DEVELOPER", [Skill.new('testing', 1), Skill.new('development', 9), Skill.new('analysis', 1), Skill.new('communication', 4), Skill.new('learning', 6)]),
  TeamMember.new("ANALYTIC", [Skill.new('testing', 2), Skill.new('development', 3), Skill.new('analysis', 9), Skill.new('communication', 7), Skill.new('learning', 4)])
]

team2 = [
  TeamMember.new("TESTER", [Skill.new('testing', 9), Skill.new('development', 3), Skill.new('analysis', 1), Skill.new('communication', 2), Skill.new('learning', 3)]),
  TeamMember.new("DEVELOPER", [Skill.new('testing', 1), Skill.new('development', 9), Skill.new('analysis', 1), Skill.new('communication', 4), Skill.new('learning', 6)]),
  TeamMember.new("ANALYTIC", [Skill.new('testing', 2), Skill.new('development', 3), Skill.new('analysis', 9), Skill.new('communication', 7), Skill.new('learning', 4)])
]


project_waterfall = Project.new(team1, RequirementCollection.new, Array.new(200) {|i| FeatureGenerator.GetFeature(i)})
project_scrum = Project.new(team2, SprintPlanning.new([], team2), Array.new(200) {|i| FeatureGenerator.GetFeature(i)})

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
g3.data :Anomaly, stat_s[1].map {|t| t[3]}
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
g5.data :Anomaly, stat_s[2].slice(0, 100).map {|t| t[3]}
g5.data :Completed, stat_s[2].slice(0, 100).map {|t| t[4]}
g5.write('scrum_cfd.png')

g6 = Gruff::StackedArea.new
g6.data :Anomalies, stat_s[3]
g6.write('scrum_anomalies.png')

g7 = Gruff::Line.new
g7.data :WithoutAnomalies, stat_s[4].slice(0, 100).map {|t| t[0]}
g7.data :WithAnomalies, stat_s[4].slice(0, 100).map {|t| t[1]}
g7.write('scrum_anomalies_impact.png')