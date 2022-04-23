class DesignedTask
  attr_reader :collected_requirement,
              :software_component

  def initialize(requirement, software_component)
    @collected_requirement = requirement
    @software_component = software_component
  end
end
