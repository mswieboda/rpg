require "./scene/start"
require "./scene/main"

module RPG
  class Stage < GSF::Stage
    getter start
    getter main

    def initialize(window : SF::RenderWindow)
      super(window)

      @start = Scene::Start.new
      @main = Scene::Main.new

      @scene = start
    end

    def check_scenes
      case scene.name
      when :start
        if scene.exit?
          @exit = true
        elsif start_scene = start.start_scene
          switch(main) if start_scene == :main
        end
      when :main
        switch(start) if scene.exit?
      end
    end
  end
end
