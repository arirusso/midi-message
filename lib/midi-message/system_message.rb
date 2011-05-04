#!/usr/bin/env ruby
#

module MIDIMessage
  
  #
  # MIDI System-Common message
  #
  class SystemCommon

    include ShortMessageBehavior
    display_name 'System Common'
    
    attr_reader :data
    
    def initialize(*a)
      options = a.pop if a.last.kind_of?(Hash)
      @data = [a[1], a[2]]
      initialize_short_message(0xF, a[0])
    end
    
  end  
  
  #
  # MIDI System-Realtime message
  #
  class SystemRealtime

    include ShortMessageBehavior
    display_name 'System Realtime'
    
    def initialize(*a)
      options = a.pop if a.last.kind_of?(Hash)
      id = options[:const] unless options.nil? || options[:const].nil?
      id ||= a[0]
      initialize_short_message(0xF, id)
    end

    def id
      @status[1]
    end

  end
  
end
