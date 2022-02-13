require './model/process.rb'

waterfall_state = WaterfallState.new
process = DevelopmentProcess.new waterfall_state

process.state.advance_stage
process.state.apply_action process.state.actions.at(0), process.state.anomalies.at(0)
process.state.advance_stage
process.state.advance_stage
process.state.apply_action process.state.actions.at(0), process.state.anomalies.at(0)
process.state.advance_stage
process.state.advance_stage
process.state.apply_action process.state.actions.at(0), process.state.anomalies.at(0)
process.state.advance_stage
process.state.advance_stage
process.state.apply_action process.state.actions.at(0), process.state.anomalies.at(0)
process.state.advance_stage
process.state.advance_stage
