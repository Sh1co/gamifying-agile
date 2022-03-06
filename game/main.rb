require 'gosu'
require 'gosu_texture_packer'
require_relative 'constants.rb'
require_relative 'states/game_state'
require_relative 'states/menu_state'
require_relative 'game'

$window = Game.new
GameState.switch(MenuState.instance)
$window.show
