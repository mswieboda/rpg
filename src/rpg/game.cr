require "./stage"

module RPG
  class Game < GSF::Game
    getter manager

    def initialize
      super(title: "RPG", target_height: 1080)

      @stage = Stage.new
    end
  end
end
