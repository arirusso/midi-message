#!/usr/bin/env ruby
#

module MIDIMessage
  
  #
  # MIDI System-Common message
  #
  class SystemCommon

    include ShortMessageBehavior
    use_display_name 'System Common'
    
    attr_reader :data
    
    def initialize(*a)
      options = a.last.kind_of?(Hash) ? a.pop : {}
      @const = options[:const]
      @data = [a[1], a[2]]
      initialize_short_message(0xF, a[0])
    end
    
  end  
  
  #
  # MIDI System-Realtime message
  #
  class SystemRealtime

    include ShortMessageBehavior
    use_display_name 'System Realtime'
    
    def initialize(*a)
      options = a.last.kind_of?(Hash) ? a.pop : {} 
      @const = options[:const]
      id = @const.values.first unless @const.nil?
      id ||= a[0]
      initialize_short_message(0xF, id)
    end

    def id
      @status[1]
    end

  end
  
end
