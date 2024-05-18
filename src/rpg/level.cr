require "./player"

module RPG
  class Level
    getter player : Player
    getter rows : Int32
    getter cols : Int32
    getter player_row : Int32
    getter player_col : Int32

    TileSize = 64

    def initialize(@player : Player, @rows = 9, @cols = 9, @player_row = 0, @player_col = 0)
    end

    def tile_size
      TileSize
    end

    def start
      player.jump(
        player_row * tile_size + (tile_size / 2).to_f32,
        player_col * tile_size + (tile_size / 2).to_f32
      )
    end

    def update(frame_time, keys : Keys, mouse : Mouse, joysticks : Joysticks)
    end

    def draw(window : SF::RenderWindow)
    end
  end
end
