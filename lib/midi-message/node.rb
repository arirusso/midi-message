#!/usr/bin/env ruby
module MIDIMessenger
  
  # this is a midi synthesizer or other midi device that's being communicated with
  # using MIDIMessenger
  module Node
    
    attr_accessor :channel, :device
    
    def initialize(device, options = {})
      @channel = @options[:channel]
      @device = device
    end
    
  end
end