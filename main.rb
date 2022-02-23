require './model/models/waterfall.rb'

waterfall_state = WaterfallRequirementsAnalysis.new [Feature.new("1"), Feature.new("2")]
process = WaterfallDevelopmentProcess.new waterfall_state

process.advance_state
process.state.advance_feature process.state.features_from.at(0)
process.state.advance_feature process.state.features_from.at(0)
process.advance_state
process.state.advance_feature process.state.features_from.at(0)
process.state.advance_feature process.state.features_from.at(0)
process.advance_state
process.state.advance_feature process.state.features_from.at(0)
process.state.advance_feature process.state.features_from.at(0)
process.advance_state
process.state.advance_feature process.state.features_from.at(0)
process.state.advance_feature process.state.features_from.at(0)
process.advance_state
process.state.advance_feature process.state.features_from.at(0)
process.state.advance_feature process.state.features_from.at(0)
process.advance_state