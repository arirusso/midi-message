#!/usr/bin/env ruby
#
module MIDIMessage

  #
  # Common Note Message Behavior
  #
  module NoteMessage

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
    include ShortMessage
    include ChannelMessage

    schema :channel, :note, :velocity
    use_display_name 'Note Off'
    use_constants 'Note', :for => :note

  end

  #
  # MIDI Note-On message
  #
  class NoteOn
    
    include NoteMessage
    include ShortMessage
    include ChannelMessage    

    schema :channel, :note, :velocity
    use_display_name 'Note On'
    use_constants 'Note', :for => :note
    
    # returns the NoteOff equivalent of this object
    def to_note_off
      NoteOff.new(channel, note, velocity)
    end

  end
  
end
