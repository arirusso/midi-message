module MIDIMessage

  # Common Note Message Behavior
  module NoteMessage

    def self.included(base)
      base.include(ChannelMessage)
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

  #
  # MIDI Note-Off message
  #
  class NoteOff

    include NoteMessage

    DATA = [:channel, :note, :velocity]
    DISPLAY_NAME = "Note Off"
    CONSTANT = { "Note" => :note }

  end

  #
  # MIDI Note-On message
  #
  class NoteOn
    
    include NoteMessage   

    DATA = [:channel, :note, :velocity]
    DISPLAY_NAME = "Note On"
    CONSTANT = { "Note" => :note }
    
    # returns the NoteOff equivalent of this object
    def to_note_off
      NoteOff.new(channel, note, velocity)
    end

  end
  
end
