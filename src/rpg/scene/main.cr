require "../player"
require "../level"
require "../levels/world"
require "../hud"

module RPG::Scene
  class Main < GSF::Scene
    getter view : GSF::View
    getter hud
    getter player
    getter level : Level

    def initialize(window)
      super(:main)

      @view = GSF::View.from_default(window).dup

      view.zoom(1 / Screen.scaling_factor)

      @player = Player.new
      @level = Levels::World.new(player)
      @hud = HUD.new
    end

    def init
      @level.start
    end

    def update(frame_time, keys : Keys, mouse : Mouse, joysticks : Joysticks)
      if keys.just_pressed?(Keys::Escape)
        @exit = true
        return
      end

      level.update(frame_time, keys, mouse, joysticks)
      hud.update(frame_time)
    end

    def draw(window)
      level.draw(window)
      hud.draw(window)
    end
  end
end
