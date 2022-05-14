require_relative './model/new_model/waterfall/waterfall'
require_relative './model/new_model/actor'
require_relative './model/new_model/skill'


testing = Skill.new "Testing", 8
tester = Actor.new "Developer", [testing]

development = Skill.new "Development", 9
developer = Actor.new "Developer", [development]

waterfall_process = WaterfallProcess.new [tester, developer]

