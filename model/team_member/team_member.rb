##
# This class represents a member of the Agile team
# All members have a set of quantified skills, which contribute
# to the team's performance

class TeamMember
  attr_reader :name,
              :communication,
              :analysis,
              :development,
              :shipping,
              :testing

  def initialize(
    name,
   communication,
   analysis,
   development,
   shipping,
   testing
  )
    @name = name
    @communication = communication
    @analysis = analysis
    @development = development
    @shipping = shipping
    @testing = testing
  end
end
