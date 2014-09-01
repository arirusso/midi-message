module MIDIMessage

  # Very simple parsing
  # for more advanced parsing check out {nibbler}[http://github.com/arirusso/nibbler]
  class Parser

    # Can take either a hex string eg Parser.new("904040")
    # or bytes eg Parser.new(0x90, 0x40, 0x40)
    # or an array of bytes eg Parser.new([0x90, 0x40, 0x40])
    def initialize(*args)
      @data = case args.first
              when Array then args.first
              when Numeric then args 
              when String then TypeConversion.hex_string_to_numeric_byte_array(args.first)
              end
    end

    # Parse the data and return a message
    def parse
      first_nibble = ((@data.first & 0xF0) >> 4)
      second_nibble = (@data.first & 0x0F)
      case first_nibble
      when 0x8 then NoteOff.new(second_nibble, @data[1], @data[2])
      when 0x9 then NoteOn.new(second_nibble, @data[1], @data[2])
      when 0xA then PolyphonicAftertouch.new(second_nibble, @data[1], @data[2])
      when 0xB then ControlChange.new(second_nibble, @data[1], @data[2])
      when 0xC then ProgramChange.new(second_nibble, @data[1])
      when 0xD then ChannelAftertouch.new(second_nibble, @data[1])
      when 0xE then PitchBend.new(second_nibble, @data[1], @data[2])
      when 0xF then case second_nibble
        when 0x0 then SystemExclusive.new(*@data)
        when 0x1..0x6 then SystemCommon.new(second_nibble, @data[1], @data[2])
        when 0x8..0xF then SystemRealtime.new(second_nibble)
        else nil
        end
      else nil
      end
    end   

  end

  def self.parse(*args)
    Parser.new(*args).parse
  end

end
