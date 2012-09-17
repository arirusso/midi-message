#!/usr/bin/env ruby
#

module MIDIMessage

  #
  # MIDI System message
  #
  module SystemMessage

    # In the case of something like SystemCommon.new(0xF2, 0x00, 0x08), the first nibble F is redundant because
    # all system messages start with 0xF and it can be assumed.
    # However, the this method looks to see if this has occurred and strips the redundancy
    # @param [Integer] byte The byte to strip of a redundant 0xF
    # @return [Integer] The remaining nibble
    def strip_redundant_nibble(byte)
      byte > 0xF ? (byte & 0x0F) : byte
    end

  end
  
  #
  # MIDI System-Common message
  #
  class SystemCommon

    include ShortMessage
    include SystemMessage
    use_display_name 'System Common'
    
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

    include ShortMessage
    include SystemMessage
    use_display_name 'System Realtime'
    
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
  
end
