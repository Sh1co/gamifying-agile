require './model/process.rb'

waterfall_state = WaterfallState.new
process = DevelopmentProcess.new waterfall_state

process.state.advance_feature process.state.requested_features.at(0)
process.state.advance_feature process.state.analyzed_features.at(0)
process.state.advance_feature process.state.requested_features.at(0)

process.state.advance_feature process.state.analyzed_features.at(0)
process.state.advance_feature process.state.analyzed_features.at(0)

process.state.advance_feature process.state.designed_features.at(0)
process.state.advance_feature process.state.designed_features.at(0)

process.state.advance_feature process.state.implemented_features.at(0)
process.state.advance_feature process.state.implemented_features.at(0)

process.state.advance_feature process.state.tested_features.at(0)