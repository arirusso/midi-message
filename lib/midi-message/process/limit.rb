#!/usr/bin/env ruby

module MIDIMessage

  module Process
    
    class Limit

      include Processor

      attr_reader :property, :range
      
      def initialize(prop, range, options = {})
        @range = range
        @property = prop
        
        initialize_processor(options)
      end

      def process_single(message)
        val = message.send(@property)
        message.send("#{@property}=", @range.min) if val < @range.min
        message.send("#{@property}=", @range.max) if val > @range.max
        message
      end

    end

  end
  
end