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
    
    def initialize(*a)
      options = a.pop if a.last.kind_of?(Hash)
      @data = [a[1], a[2]]
      initialize_simple_message(0xF, a.first)
    end
    
  end  
  
  #
  # MIDI System-Realtime message
  #
  class SystemRealtime

    include SimpleMessageBehavior
    display_name 'System Realtime'

    attr_reader :status
    
    def initialize(*a)
      options = a.pop if a.last.kind_of?(Hash)
      id = options[:const] unless options.nil?
      id ||= a.first
      initialize_simple_message(0xF, id)
    end

    def id
      @status[1]
    end

  end
  
end
