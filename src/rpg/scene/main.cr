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
      HUD.init
    end

    def init
      @level.start
    end

    def update(frame_time, keys : Keys, mouse : Mouse, joysticks : Joysticks)
      if keys.just_pressed?(Keys::Escape)
        @exit = true
        return
      end

      HUD.update(frame_time)
      level.update(frame_time, keys, mouse, joysticks)
    end

    def draw(window)
      view.set_current

      level.draw(window)

      view.set_default_current

      HUD.draw(window)
    end
  end
end
