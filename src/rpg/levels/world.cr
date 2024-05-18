require "../level"

module RPG::Levels
  class World < RPG::Level
    TileColor = SF::Color.new(0, 128, 0)

    def initialize(player)
      super(player, rows: 19, cols: 19, player_row: 9, player_col: 9)
    end

    def update(frame_time, keys : Keys, mouse : Mouse, joysticks : Joysticks)
      player.update(frame_time, keys)
    end

    def draw(window : SF::RenderWindow)
      draw_tiles(window)
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
