#!/usr/bin/env ruby
#
module MIDIMessage
  
  #
  # MIDI System-Common message
  #
  class SystemCommon

    include SimpleMessageBehavior
    display_name 'System Common'

    attr_reader :status,
                :data
    
    def initialize(status_nibble_2, data_byte_1 = nil, data_byte_2 = nil)
      @data = [data_byte_1, data_byte_2]
      initialize_simple_message(0xF, status_nibble_2)
    end

    def self.find(const_name, data_byte_1 = nil, data_byte_2 = nil)
      c = const(const_name)
      new(c, data_byte_1, data_byte_2)
    end
    
  end  
  
  #
  # MIDI System-Realtime message
  #
  class SystemRealtime

    include SimpleMessageBehavior
    display_name 'System Realtime'

    attr_reader :status
    
    def initialize(id)
      initialize_simple_message(0xF, id)
    end

    def self.find(const_name)
      c = const(const_name)
      new(c)
    end

    def id
      @status[1]
    end

  end
  
end
