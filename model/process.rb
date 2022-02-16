require_relative 'actions.rb'
require_relative 'anomalies.rb'
require_relative 'features.rb'
require 'ruby-enum'

class ProcessState
  # @abstract
  attr_accessor :anomalies,
                :actions,
                :requested_features,
                :analyzed_features,
                :designed_features,
                :implemented_features,
                :tested_features
  def initialize(anomalies, actions, features)
    @anomalies = anomalies
    @actions = actions
    @requested_features = features
    @analyzed_features = Array[]
    @designed_features = Array[]
    @implemented_features = Array[]
    @tested_features = Array[]
  end
  def advance_feature(feature)
    raise NotImplementedError, "#{self.class} has not implemented method '#{__method__}'"
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
  attr_accessor :stage
  def initialize(
    anomalies=Array[],
    actions=Array[],
    features=Array[RequestedRequirement.new("1"), RequestedRequirement.new("2")],
    stage=WaterfallStage::REQUIREMENTS_ANALYSIS
  )
    super anomalies, actions, features
    @stage = stage
  end

  def advance_feature(feature)
    if self.anomalies.length > 0
      puts "You cannot advance this feature if there are anomalies!"
    else
      if self.stage == WaterfallStage::REQUIREMENTS_ANALYSIS
        idx = self.requested_features.index feature
        if idx.nil?
          puts "Too early to advance '#{feature.to_s}'. There are still requirements to analyze!"
        else
          self.analyzed_features.push feature
          self.requested_features.delete_at self.requested_features.index feature
          puts "Advanced '#{feature.to_s}' from analyzing to designing!"
          if self.requested_features.length == 0
            self.stage = WaterfallStage::DESIGN
            puts "Transitioning from REQUIREMENTS_ANALYSIS to DESIGN"
          end
        end

      elsif self.stage == WaterfallStage::DESIGN
        idx = self.analyzed_features.index feature
        if idx.nil?
          puts "Too early to advance '#{feature.to_s}'. There are still features to design!"
        else
          self.designed_features.push feature
          self.analyzed_features.delete_at self.analyzed_features.index feature
          puts "Advanced '#{feature.to_s}' from designing to implementing!"
          if self.analyzed_features.length == 0
            self.stage = WaterfallStage::IMPLEMENTATION
            puts "Transitioning from DESIGN to IMPLEMENTATION"
          end
        end

      elsif self.stage == WaterfallStage::IMPLEMENTATION
        idx = self.designed_features.index feature
        if idx.nil?
          puts "Too early to advance '#{feature.to_s}'. There are still features to implement!"
        else
          self.implemented_features.push feature
          self.designed_features.delete_at self.designed_features.index feature
          puts "Advanced '#{feature.to_s}' from implementing to testing!"
          if self.designed_features.length == 0
            self.stage = WaterfallStage::TESTING
            puts "Transitioning from IMPLEMENTATION to TESTING"
          end
        end

      elsif self.stage == WaterfallStage::TESTING
        idx = self.implemented_features.index feature
        if idx.nil?
          puts "Too early to advance '#{feature.to_s}'. There are still features to test!"
        else
          self.tested_features.push feature
          self.implemented_features.delete_at self.implemented_features.index feature
          puts "Advanced '#{feature.to_s}' from implementing to testing!"
          if self.implemented_features.length == 0
            self.stage = WaterfallStage::MAINTENANCE
            puts "Transitioning from TESTING to MAINTENANCE"
          end
        end

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
