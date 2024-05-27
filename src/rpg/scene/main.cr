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

      update_bag_ui(keys, joysticks)

      return if BagUI.shown?

      HUD.update(frame_time)
      level.update(frame_time, keys, mouse, joysticks)
    end

    def update_bag_ui(keys, joysticks)
      return unless keys.just_pressed?([Keys::B, Keys::Tab]) || joysticks.just_pressed?([Joysticks::Back])

      BagUI.shown? ? BagUI.hide : BagUI.show
    end

    def draw(window)
      level.draw(window)
      HUD.draw(window)
      BagUI.draw(window, player.bag)
    end
  end
end
