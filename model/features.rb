class Feature
  attr_reader :name

  def initialize(name)
    @name = name
  end

  def to_s
    @name
  end
end

class RequestedFeature < Feature
end

class AnalyzedFeature < Feature
end

class DesignedFeature < Feature
end

class ImplementedFeature < Feature
end

class TestedFeature < Feature
end