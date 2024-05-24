require "../level"

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

    def init_dialog_data
      text = "Listen up! I am making this stupid video game \
        example for your lazy butt, I expect obedience."
      choices = [{key: "shut up", label: "shut up"}, {key: "more", label: "tell me more"}, {key: "okay", label: "okay"}]
      more_choices = [{key: "okay", label: "fine"}]
      battle_choices = [{key: "battle_yes", label: "yes"}, {key: "battle_no", label: "no"}]

      @dd["npc1"] = GSF::Dialog::Data.new
      @dd["npc1"]["start"] = {message: text, choices: choices}
      @dd["npc1"]["more"] = {message: "There is not much more to tell.", choices: more_choices}
      @dd["npc1"]["okay"] = {message: "Do you want to start the battle?", choices: battle_choices}

      @dd["npc2"] = GSF::Dialog::Data.new
      @dd["npc2"]["start"] = {message: "Hi!", choices: [{key: "hi", label: "hi"}]}
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
