require "../level"
require "../dialog"

module RPG::Levels
  class World < RPG::Level
    getter characters : Array(Character)
    getter sound_bump : SF::Sound

    @dialog : Dialog

    TileColor = SF::Color.new(0, 128, 0)

    def initialize(player)
      super(player, rows: 19, cols: 19, player_row: 9, player_col: 9)

      @characters = [] of Character
      @sound_bump = SF::Sound.new(SF::SoundBuffer.from_file("./assets/bump.ogg"))
      @dialog = Dialog.new
    end

    def start
      super

      char1 = Character.new
      char1.jump_to_tile(3, 5, tile_size)

      char2 = Character.new
      char2.jump_to_tile(9, 1, tile_size)

      @characters << char1
      @characters << char2

      init_dialog_data

      @dialog.hide_reset
      @dialog.show("first")
    end

    def init_dialog_data
      text = "Listen up! I am making this stupid video game \
        example for your lazy butt, I expect obedience."
      choices = [{key: "more", label: "tell me more"}, {key: "okay", label: "okay"}]
      more_choices = [{key: "okay", label: "fine"}]
      battle_choices = [{key: "yes", label: "yes"}, {key: "no", label: "no"}]

      data = @dialog.data
      data["first"] = {message: text, choices: choices}
      data["more"] = {message: "There is not much more to tell.", choices: more_choices}
      data["okay"] = {message: "Do you want to start the battle?", choices: battle_choices}
    end

    def update(frame_time, keys : Keys, mouse : Mouse, joysticks : Joysticks)
      @dialog.update(keys)

      if choice = @dialog.choice_selected
        puts ">>> choice: #{choice}"
      end

      return if @dialog.show?

      characters.each(&.update(frame_time))
      player.update(frame_time, keys)
      player_collision_checks
    end

    def player_collision_checks
      characters.each do |char|
        collision_x, collision_y = player.collision(char)

        if collision_x || collision_y
          player.move(-player.dx, 0) if collision_x
          player.move(0, -player.dy) if collision_y

          play_bump_sound

          break
        end
      end
    end

    def play_bump_sound
      return if sound_bump.status.playing?

      sound_bump.pitch = rand(0.9..1.1)
      sound_bump.play
    end

    def draw(window : SF::RenderWindow)
      draw_tiles(window)
      characters.each(&.draw(window))
      player.draw(window)
      @dialog.draw(window)
    end

    def draw_tiles(window)
      rows.times do |row|
        cols.times do |col|
          x = col * tile_size
          y = row * tile_size

          rect = SF::RectangleShape.new({tile_size, tile_size})
          rect.fill_color = TileColor
          rect.outline_color = SF::Color::Black
          rect.outline_thickness = 1
          rect.position = {x, y}

          window.draw(rect)
        end
      end
    end
  end
end
