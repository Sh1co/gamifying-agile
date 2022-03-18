require './model/models/waterfall.rb'
require_relative 'model/task/task_context'
require_relative 'model/anomaly/anomalies_context'

waterfall_state = WaterfallRequirementsAnalysis.new [RequirementsAnalysisTask.new("1"), RequirementsAnalysisTask.new("2")],
                                                    TaskContext.new(WaterfallTaskAdvancingStrategy.new),
                                                    AnomaliesContext.new(SimpleAnomaliesGenerationStrategy.new)
process = WaterfallDevelopmentProcess.new waterfall_state

process.advance_state
process.state.advance_task process.state.features_from.at(0)
process.state.advance_task process.state.features_from.at(0)
process.advance_state

process.state.advance_task process.state.features_from.at(0)
process.state.advance_task process.state.features_from.at(0)
process.advance_state

process.state.advance_task process.state.features_from.at(0)
puts process.state.anomalies
process.state.actions[0].apply(process.state.anomalies[0], process.state)
process.state.actions[0].apply(process.state.anomalies[0], process.state)
process.state.advance_task process.state.features_from.at(0)
process.state.advance_task process.state.features_from.at(0)
process.advance_state

process.state.advance_task process.state.features_from.at(0)
process.state.advance_task process.state.features_from.at(0)
process.advance_state

process.state.advance_task process.state.features_from.at(0)
process.state.advance_task process.state.features_from.at(0)
process.advance_state