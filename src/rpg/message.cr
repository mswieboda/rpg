module RPG
  class Message < GSF::BottomCenteredMessage
    def font
      Font.default
    end

    def max_lines
      3
    end
  end
end
