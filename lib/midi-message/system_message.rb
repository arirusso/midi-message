module MIDIMessage

  # Common MIDI system message behavior
  module SystemMessage

    STATUS = 0xF

    def self.included(base)
      base.send(:include, Message)
    end

    # In the case of something like SystemCommon.new(0xF2, 0x00, 0x08), the first nibble F is redundant because
    # all system messages start with 0xF and it can be assumed.
    # However, the this method looks to see if this has occurred and strips the redundancy
    # @param [Fixnum] byte The byte to strip of a redundant 0xF
    # @return [Fixnum] The remaining nibble
    def strip_redundant_nibble(byte)
      byte > STATUS ? (byte & 0x0F) : byte
    end

  end

end
