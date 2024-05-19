require "./stage"

module RPG
  class Game < GSF::Game
    getter manager

    def initialize
      style = SF::Style::None

      {% if flag?(:linux) %}
        mode.width -= 50
        mode.height -= 100

        style = SF::Style::Default
      {% end %}

      super(title: "RPG", style: style)

      @stage = Stage.new(window)
    end
  end
end
