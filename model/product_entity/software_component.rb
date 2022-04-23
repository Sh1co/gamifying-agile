class SoftwareComponent
  attr_reader :name,
              :complexity

  def initialize(name, complexity)
    @name = name
    @complexity = complexity
  end
end
