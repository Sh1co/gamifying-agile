require_relative 'actions.rb'
require_relative 'anomalies.rb'
require 'ruby-enum'

class ProcessState
  # @abstract
  attr_accessor :anomalies, :actions, :stage

  def initialize(anomalies, actions, stage)
    @anomalies = anomalies
    @actions = actions
    @stage = stage
  end

  def advance_stage
    raise NotImplementedError, "#{self.class} has not implemented method '#{__method__}'"
  end

  def apply_action(action, anomaly)
    if action.action_applicable? anomaly
      @anomalies.delete_at(@anomalies.index(anomaly))
      puts "Solved #{anomaly.to_s} with #{action.to_s}"
    else
      puts "Cannot solve #{anomaly.to_s} with #{action.to_s}"
    end
  end
end

class WaterfallStage
  include Ruby::Enum

  define :REQUIREMENTS_ANALYSIS, 'requirements_analysis'
  define :DESIGN, 'design'
  define :IMPLEMENTATION, 'implementation'
  define :TESTING, 'testing'
  define :MAINTENANCE, 'maintenance'
end

class WaterfallState < ProcessState
  def initialize(
    anomalies=Array[NewRequirement.new],
    actions=Array[CollectRequirements.new],
    stage=WaterfallStage::REQUIREMENTS_ANALYSIS
  )
    super
  end

  def advance_stage
    if self.anomalies.length > 0
      puts "You cannot go to the next stage if there are anomalies!"
    else
      if self.stage == WaterfallStage::REQUIREMENTS_ANALYSIS
        self.stage = WaterfallStage::DESIGN
        self.actions = Array[DesignSystem.new]
        self.anomalies = Array[LackOfDesign.new]
        puts "Transitioned from Requirements Analysis to the Design stage"
      elsif self.stage == WaterfallStage::DESIGN
        self.stage = WaterfallStage::IMPLEMENTATION
        self.actions = Array[Code.new]
        self.anomalies = Array[FeatureToImplement.new]
        puts "Transitioned from Design to the Implementation stage"
      elsif self.stage == WaterfallStage::IMPLEMENTATION
        self.stage = WaterfallStage::TESTING
        self.actions = Array[Test.new]
        self.anomalies = Array[UntestedFeature.new]
        puts "Transitioned from Implementation to the Testing stage"
      elsif self.stage == WaterfallStage::TESTING
        self.stage = WaterfallStage::MAINTENANCE
        self.actions = Array[]
        puts "Transitioned from Testing to the Maintenance stage"
      elsif self.stage == WaterfallStage::MAINTENANCE
        puts "We've reached the last stage!"
      end
    end
  end
end

class DevelopmentProcess
  attr_reader :state

  def initialize(st)
    @state = st
  end  
end
