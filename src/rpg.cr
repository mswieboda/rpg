require "game_sf"

require "./rpg/game"

module RPG
  alias Keys = GSF::Keys
  alias Mouse = GSF::Mouse
  alias Joysticks = GSF::Joysticks
  alias Screen = GSF::Screen
  alias Timer = GSF::Timer

  Game.new.run
end
