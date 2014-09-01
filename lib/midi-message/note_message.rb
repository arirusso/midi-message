module MIDIMessage

  #
  # Common Note Message Behavior
  #
  module NoteMessage

    def self.included(base)
      base.include(ChannelMessage)
    end

    # the octave number of the note
    def octave
      (note / 12) -1
    end
    alias_method :oct, :octave
    
    # set the octave number of the note
    def octave=(val)
      self.note = ((val + 1) * 12) + abs_note
      self
    end
    alias_method :oct=, :octave=
    
    # how many half-steps is this note above the closest C
    def abs_note
      note - ((note / 12) * 12)
    end
    
    # the name of the note without its octave e.g. F#
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
