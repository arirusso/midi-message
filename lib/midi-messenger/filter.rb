#!/usr/bin/env ruby
module MIDIMessenger
  
  class Filter
    
    def self.only_channel(message, channel)
      message.clone.channel = channel if (message.respond_to?(:channel=) && !channel.nil?)
      message
    end
    
  end
  
end