module RPG
  class Message < GSF::BottomCenteredMessage
    def font
      Font.default
    end

    def max_lines
      3
    end

    def bump_sound_buffer
      @@bump_sound_buffer ||= SF::SoundBuffer.from_file("./assets/sounds/bump.ogg")
    end

    def next_page_sound_buffer
      bump_sound_buffer
    end

    def next_page_sound_pitch
      2
    end

    def next_choice_sound_buffer
      bump_sound_buffer
    end

    def next_choice_sound_pitch
      3
    end

    def prev_choice_sound_buffer
      bump_sound_buffer
    end

    def prev_choice_sound_pitch
      3
    end

    def type_duration
      25.milliseconds
    end
  end
end
