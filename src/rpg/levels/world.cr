require "../level"

module RPG::Levels
  class World < RPG::Level
    getter characters : Array(Character)

    TileColor = SF::Color.new(0, 128, 0)

    def initialize(player)
      super(player, rows: 19, cols: 19, player_row: 9, player_col: 9)

      @characters = [] of Character
    end

    def start
      super

      char1 = Character.new
      char1.jump_to_tile(3, 5, tile_size)

      char2 = Character.new
      char2.jump_to_tile(9, 1, tile_size)

      @characters << char1
      @characters << char2
    end

    def update(frame_time, keys : Keys, mouse : Mouse, joysticks : Joysticks)
      characters.each(&.update(frame_time))
      player.update(frame_time, keys)
    end

    def draw(window : SF::RenderWindow)
      draw_tiles(window)
      characters.each(&.draw(window))
      player.draw(window)
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
