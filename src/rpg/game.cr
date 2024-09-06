require "./stage"

module RPG
  class Game < GSF::Game
    getter manager

    def initialize
      super(title: "RPG")

      @stage = Stage.new
    end
  end
end
