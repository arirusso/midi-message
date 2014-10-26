module MIDIMessage

  # Common Note Message Behavior
  module NoteMessage

    def self.included(base)
      base.send(:include, ChannelMessage)
    end

    # The octave number of the note
    # @return [Fixnum]
    def octave
      (note / 12) - 1
    end
    alias_method :oct, :octave

    # Set the octave number of the note
    # @param [Fixnum] value
    # @return [NoteMessage] self
    def octave=(value)
      self.note = ((value + 1) * 12) + abs_note
      self
    end
    alias_method :oct=, :octave=

    # How many half-steps is this note above the closest C
    # @return [Fixnum]
    def abs_note
      note - ((note / 12) * 12)
    end

    # The name of the note without its octave e.g. F#
    # @return [String]
    def note_name
      name.split(/-?\d\z/).first
    end

  end

end
