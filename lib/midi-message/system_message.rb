#!/usr/bin/env ruby
#
module MIDIMessage
  
  #
  # MIDI System-Common message
  #
  class SystemCommon

    attr_reader :status,
                :data
    
    def initialize(status_nibble_2, data_byte_1 = nil, data_byte_2 = nil)
      @status = [0xF, status_nibble_2]
      @data = [data_byte_1, data_byte_2]
    end
    
  end  
  
  #
  # MIDI System-Realtime message
  #
  class SystemRealtime
    
    attr_reader :status
    
    def initialize(id)
      @status = [0xF, id]
    end

    def id
      @status[1]
    end

  end
  
end