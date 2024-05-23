require "../level"

module RPG::Levels
  class World < RPG::Level
    Debug = false
    TileColor = SF::Color.new(0, 128, 0)

    def initialize(player)
      super(player, rows: 19, cols: 19, player_row: 9, player_col: 9)
    end

    def start
      super

      npc1 = NonPlayableCharacter.new
      npc1.jump_to_tile(3, 5, tile_size)

      npc2 = NonPlayableCharacter.new
      npc2.jump_to_tile(9, 1, tile_size)

      @npcs << npc1
      @npcs << npc2

      if Debug
        init_dialog_data

        dialog.hide_reset
        dialog.show("first")
      end
    end

    def init_dialog_data
      text = "Listen up! I am making this stupid video game \
        example for your lazy butt, I expect obedience."
      choices = [{key: "shut up", label: "shut up"}, {key: "more", label: "tell me more"}, {key: "okay", label: "okay"}]
      more_choices = [{key: "okay", label: "fine"}]
      battle_choices = [{key: "yes", label: "yes"}, {key: "no", label: "no"}]

      data = @dialog.data
      data["first"] = {message: text, choices: choices}
      data["more"] = {message: "There is not much more to tell.", choices: more_choices}
      data["okay"] = {message: "Do you want to start the battle?", choices: battle_choices}
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
