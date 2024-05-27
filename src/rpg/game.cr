require "./stage"

module RPG
  class Game < GSF::Game
    getter manager

    def initialize
      super(title: "RPG", style: SF::Style::Fullscreen)

      @stage = Stage.new(window)
    end
  end
end
