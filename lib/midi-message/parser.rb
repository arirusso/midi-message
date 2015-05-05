module MIDIMessage

  # Simple message parsing
  # For more advanced parsing check out {nibbler}[http://github.com/arirusso/nibbler]
  class Parser

    MESSAGE_TYPE = [
      NoteOff,
      NoteOn,
      PolyphonicAftertouch,
      ControlChange,
      ProgramChange,
      ChannelAftertouch,
      PitchBend,
      SystemMessage
    ].freeze

    SYSTEM_MESSAGE_TYPE = [
      SystemExclusive,
      SystemCommon,
      SystemRealtime
    ].freeze

    # Can take either a hex string eg Parser.new("904040")
    # or bytes eg Parser.new(0x90, 0x40, 0x40)
    # or an array of bytes eg Parser.new([0x90, 0x40, 0x40])
    # @param [Array<Fixnum>, *Fixnum, String] args
    # @return [MIDIMessage]
    def self.parse(*args)
      parser = new(*args)
      parser.parse
    end

    # Can take either a hex string eg Parser.new("904040")
    # or bytes eg Parser.new(0x90, 0x40, 0x40)
    # or an array of bytes eg Parser.new([0x90, 0x40, 0x40])
    # @param [Array<Fixnum>, *Fixnum, String] args
    # @return [MIDIMessage]
    def initialize(*args)
      @data = case args.first
              when Array then args.first
              when Numeric then args
              when String then TypeConversion.hex_string_to_numeric_byte_array(args.first)
              end
    end

    # Parse the data and return a message
    # @return [MIDIMessage]
    def parse
      first_nibble = ((@data.first & 0xF0) >> 4)
      second_nibble = (@data.first & 0x0F)
      klass = MESSAGE_TYPE.find { |type| type::STATUS == first_nibble }
      if klass == SystemMessage
        build_system_message(second_nibble)
      else
        klass.new(second_nibble, *@data.drop(1))
      end
    end

    private

    def build_system_message(second_nibble)
      klass = SYSTEM_MESSAGE_TYPE.find do |type|
        second_nibble == type::ID ||
          (type::ID.kind_of?(Range) && type::ID.include?(second_nibble))
      end
      if klass == SystemExclusive
        SystemExclusive.new(*@data)
      else
        klass.new(second_nibble, *@data.drop(1))
      end
    end

  end

  # Shortcut to Parser.parse
  # @param [Array<Fixnum>, *Fixnum, String] args
  # @return [MIDIMessage]
  def self.parse(*args)
    Parser.parse(*args)
  end

end
