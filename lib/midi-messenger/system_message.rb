#!/usr/bin/env ruby
#
# This file contains the non-exclusive system messages
#
module MIDIMessenger
  
  #
  # MIDI System-Common message
  #
  class SystemCommon
    
    def initialize(*a)
      initialize_midi_message(0xF, *a)
    end
    
    def self.from_hex_string(hex_digits)
    end
    
  end  
  
  #
  # MIDI System-Realtime message
  #
  class SystemRealtime
    
    attr_reader :status_nibble_1, :status_nibble_2
    
    def initialize(id)
      @status_nibble_1 = 0xF
      @status_nibble_2 = id
    end
    
    alias_method :id, :status_nibble_2
  
    def self.from_hex_string(hex_digits)
      hex_digits.slice!(0,1) # get rid of the 0xF 
      object = new(hex_digits.slice!(1,1).hex)
      { :object => object, :remaining_hexits => hex_digits }
    end
    
  end
  
end