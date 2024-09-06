require "../player"
require "../level"
require "../levels/world"
require "../hud"
require "../item"
require "../bag_ui"

module RPG::Scene
  class Main < GSF::Scene
    getter player
    getter level : Level

    CenteredViewPadding = 128

    def initialize
      super(:main)

      @player = Player.new
      @level = Levels::World.new(player)
      HUD.init
    end

    def init
      Item.init_data
      @level.start
      view_movement
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
      view_movement if player.moved?
    end

    def view_movement
      view = Screen.view.dup

      # puts ">>> view_movement pre  c: [#{view.center.x}, #{view.center.y}]" # s: [#{Screen.width}, #{Screen.height}]"

      cx = player.x
      cy = player.y + Screen.height / 4

      # TODO: this is broken
      # w = Screen.width / 2 - CenteredViewPadding
      # h = Screen.height / 4 - CenteredViewPadding

      # cx = w if cx < w
      # cy = h if cy < h

      # cx = level.width - w if cx > level.width - w
      # cy = level.height - h if cy > level.height - h

      view.center = {cx, cy}

      # puts ">>> view_movement post c: [#{view.center.x}, #{view.center.y}]"

      Screen.view = view
    end

    def draw(window)
      level.draw(window)
      HUD.draw(window)
      BagUI.draw(window, player.bag)
    end
  end
end
