module MIDIMessage

  #
  # MIDI Channel Aftertouch message
  #
  class ChannelAftertouch

    include ChannelMessage

    DATA = [:channel, :value]
    DISPLAY_NAME = "Channel Aftertouch"
    
  end
  ChannelPressure = ChannelAftertouch

  #
  # MIDI Control Change message
  #
  class ControlChange

    include ChannelMessage

    DATA = [:channel, :index, :value]
    DISPLAY_NAME = "Control Change"
    CONSTANT = { "Control Change" => :index }
   
  end  
  Controller = ControlChange #shortcut

  #
  # MIDI Pitch Bend message
  #
  class PitchBend

    include ChannelMessage

    DATA = [:channel, :low, :high]
    DISPLAY_NAME = "Pitch Bend"

  end

  #
  # MIDI Polyphonic (note specific) Aftertouch message
  #
  class PolyphonicAftertouch

    include ChannelMessage

    DATA = [:channel, :note, :value]
    DISPLAY_NAME = "Polyphonic Aftertouch"
    CONSTANT = { "Note" => :note }

  end
  PolyAftertouch = PolyphonicAftertouch
  PolyPressure = PolyphonicAftertouch
  PolyphonicPressure = PolyphonicAftertouch

  #
  # MIDI Program Change message
  #
  class ProgramChange

    include ChannelMessage

    DATA = [:channel, :program]
    DISPLAY_NAME = "Program Change"

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

  #
  # MIDI System-Common message
  #
  class SystemCommon

    include SystemMessage

    DISPLAY_NAME = "System Common"
    
    attr_reader :data
    
    def initialize(*a)
      options = a.last.kind_of?(Hash) ? a.pop : {}
      @const = options[:const]
      id = @const.nil? ? a.shift : @const.value
      id = strip_redundant_nibble(id)
      initialize_short_message(0xF, id)
      @data = [a[0], a[1]]
    end
    
  end  
  
  #
  # MIDI System-Realtime message
  #
  class SystemRealtime

    include SystemMessage

    DISPLAY_NAME = "System Realtime"
    
    def initialize(*a)
      options = a.last.kind_of?(Hash) ? a.pop : {} 
      @const = options[:const]
      id = @const.nil? ? a[0] : @const.value
      id = strip_redundant_nibble(id)
      initialize_short_message(0xF, id)
    end

    def id
      @status[1]
    end

  end

  module SystemExclusive

    # A SysEx command message
    # A command message is identified by having a status byte equal to 0x12
    class Command

      include SystemExclusive

      attr_accessor :data
      alias_method :value, :data

      TypeByte = 0x12
      
      def initialize(address, data, options = {})
        # store as a byte if it's a single byte
        @data = (data.kind_of?(Array) && data.length.eql?(1)) ? data[0] : data
        initialize_sysex(address, options)
      end
      
    end
    
    # A SysEx request message
    # A request message is identified by having a status byte equal to 0x11
    class Request

      include SystemExclusive
      
      attr_reader :size
      alias_method :value, :size

      TypeByte = 0x11
      
      def initialize(address, size, options = {})
        self.size = (size.kind_of?(Array) && size.length.eql?(1)) ? size[0] : size
        initialize_sysex(address, options)
      end
      
      def size=(val)
        # accepts a Numeric or Array but
        # must always store value as an array of three bytes
        size = []
        if val.kind_of?(Array) && val.size <= 3
          size = val
        elsif val.kind_of?(Numeric) && (val + 1) / 247 <= 2
          size = []
          div, mod = *val.divmod(247)
          size << mod unless mod.zero?
          div.times { size << 247 }
        end
        (3 - size.size).times { size.unshift 0 }
        @size = size
      end
      
    end

  end
  
end

