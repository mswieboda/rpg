require "../level"
require "yaml"

module RPG::Levels
  class World < RPG::Level
    TileColor = SF::Color.new(0, 63, 0)

    def initialize(player)
      super(player, rows: 19, cols: 19, player_row: 9, player_col: 9)
    end

    def start
      super

      npc1 = NonPlayableCharacter.new(dialog_key: "npc1")
      npc1.jump_to_tile(3, 5, tile_size)

      npc2 = NonPlayableCharacter.new(dialog_key: "npc2")
      npc2.jump_to_tile(9, 1, tile_size)

      @npcs << npc1
      @npcs << npc2
    end

    def dialog_yml_file
      "./assets/dialog/world.yml"
    end

    def draw_tile(window, x, y)
      rect = SF::RectangleShape.new({tile_size, tile_size})
      rect.fill_color = TileColor
      rect.outline_color = SF::Color::Black
      rect.outline_thickness = 2
      rect.position = {x, y}

      window.draw(rect)
    end
  end
end
