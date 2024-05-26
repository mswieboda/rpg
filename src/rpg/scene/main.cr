require "../player"
require "../level"
require "../levels/world"
require "../hud"

module RPG::Scene
  class Main < GSF::Scene
    getter hud
    getter player
    getter level : Level

    def initialize
      super(:main)

      @player = Player.new
      @level = Levels::World.new(player)
      HUD.init
    end

    def init
      @level.start
    end

    def update(frame_time, keys : Keys, mouse : Mouse, joysticks : Joysticks)
      if keys.just_pressed?(Keys::Escape) || joysticks.just_pressed?(Joysticks::Back)
        @exit = true
        return
      end

      HUD.update(frame_time)
      level.update(frame_time, keys, mouse, joysticks)
    end

    def draw(window)
      level.draw(window)
      HUD.draw(window)
    end
  end
end
