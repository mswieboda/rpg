require "../player"
require "../level"
require "../levels/world"
require "../hud"
require "../bag_ui"

module RPG::Scene
  class Main < GSF::Scene
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

      BagUI.update(keys, joysticks) unless level.dialog.show?

      if BagUI.show?
        HUD.clear_action
        return
      end

      HUD.update(frame_time)
      level.update(frame_time, keys, mouse, joysticks)
    end

    def draw(window)
      level.draw(window)
      HUD.draw(window)
      BagUI.draw(window, player.bag)
    end
  end
end
