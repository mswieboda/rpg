require "../level"
require "yaml"

module RPG::Levels
  class World < RPG::Level
    TileColor = SF::Color.new(0, 63, 0)

    def initialize(player)
      super(player, rows: 19, cols: 29, player_row: 9, player_col: 9)
    end

    def start
      super

      @objs << NonPlayableCharacter.new(*to_tile(3, 5), "npc1")
      @objs << NonPlayableCharacter.new(*to_tile(9, 1), "npc2")
      @objs << Sign.new(*to_tile(7, 7), "sign1")

      player.bag.add("apple")
      player.bag.add("apple")
      player.bag.add("banana")
      player.bag.add("orange")
      player.bag.add("orange")
      player.bag.add("orange")
      player.bag.add("pepperoni_pizza")
      player.bag.add("pepperoni_pizza")
      player.bag.add("pepperoni_pizza")
    end

    def dialog_yml_file
      "./assets/data/dialog/world.yml"
    end

    def draw_tile(window, x, y)
      rect = SF::RectangleShape.new({tile_size, tile_size})
      rect.fill_color = TileColor
      rect.outline_color = SF::Color.new(17, 17, 17, 51)
      rect.outline_thickness = -1
      rect.position = {x, y}

      window.draw(rect)
    end
  end
end
