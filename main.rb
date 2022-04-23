# require './model/models/waterfall.rb'
# require_relative 'model/task/task_context'
# require_relative 'model/anomaly/anomalies_context'
#
# waterfall_state = WaterfallRequirementsAnalysis.new [RequirementsAnalysisTask.new("1"), RequirementsAnalysisTask.new("2")],
#                                                     TaskContext.new(WaterfallTaskAdvancingStrategy.new),
#                                                     AnomaliesContext.new(SimpleAnomaliesGenerationStrategy.new)
# process = WaterfallDevelopmentProcess.new waterfall_state
#
# process.switch_state process.state.next_states[0]
# process.state.advance_task process.state.current_tasks.at(0)
# process.state.advance_task process.state.current_tasks.at(0)
# process.switch_state process.state.next_states[0]
#
# process.state.advance_task process.state.current_tasks.at(0)
# process.state.advance_task process.state.current_tasks.at(0)
# process.switch_state process.state.next_states[0]
#
# process.state.advance_task process.state.current_tasks.at(0)
# puts process.state.anomalies
# process.state.actions[0].apply(process.state.anomalies[0], process.state)
# process.state.actions[0].apply(process.state.anomalies[0], process.state)
# process.state.advance_task process.state.current_tasks.at(0)
# process.state.advance_task process.state.current_tasks.at(0)
# process.switch_state process.state.next_states[0]
#
# process.state.advance_task process.state.current_tasks.at(0)
# process.state.advance_task process.state.current_tasks.at(0)
# process.switch_state process.state.next_states[0]
#
# process.state.advance_task process.state.current_tasks.at(0)
# process.state.advance_task process.state.current_tasks.at(0)
# process.switch_state process.state.next_states[0]

require_relative './model/team_member/team_member'

project_manager = TeamMember.new("Project Manager", 9, 8, 3, 2, 6)
junior_dev = TeamMember.new("Junior Dev", 4, 3, 6, 6, 6)
senior_dev = TeamMember.new("Senior Dev", 7, 8, 9, 9, 8)

