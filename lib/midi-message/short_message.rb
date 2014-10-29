module MIDIMessage

  # Common behavior amongst all Message types
  module ShortMessage

    include MIDIMessage # this enables ..kind_of?(MIDIMessage)

    attr_reader :name,
                :status,
                :verbose_name

    # Initialize the message status
    # @param [Fixnum] status_nibble_1 The first nibble of the status
    # @param [Fixnum] status_nibble_2 The second nibble of the status
    def initialize_short_message(status_nibble_1, status_nibble_2)
      @status = [status_nibble_1, status_nibble_2]
      populate_using_const
    end

    # Byte array representation of the message eg [0x90, 0x40, 0x40] for NoteOn(0x40, 0x40)
    # @return [Array<Fixnum>] The array of bytes in the MIDI message
    def to_a
      data = @data.nil? ? [] : [@data[0], @data[1]]
      [(@status[0] << 4) + @status[1], *data].compact
    end
    alias_method :to_byte_a, :to_a
    alias_method :to_byte_array, :to_a
    alias_method :to_bytes, :to_a

    # String representation of the message's bytes eg "904040" for NoteOn(0x40, 0x40)
    # @return [String] The bytes of the message as a string of hex bytes
    def to_hex_s
      TypeConversion.numeric_byte_array_to_hex_string(to_a)
    end
    alias_method :to_bytestr, :to_hex_s

    protected

    def self.included(base)
      base.send(:include, Constant::Loader::InstanceMethods)
      base.send(:extend, Constant::Loader::ClassMethods)
    end

  end

end
