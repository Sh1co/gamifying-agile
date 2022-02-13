class Anomaly
  # @abstract
end

class NewRequirement < Anomaly
  def to_s
    "'NewRequirement'"
  end
end

class LackOfDesign < Anomaly
  def to_s
    "'LackOfDesign'"
  end
end

class FeatureToImplement < Anomaly
  def to_s
    "'FeatureToImplement'"
  end
end

class UntestedFeature < Anomaly
  def to_s
    "'UntestedFeature'"
  end
end