#!/usr/bin/env ruby

module MIDIMessage

  module Process
    
    class Limit

      include Processor

      attr_reader :property, :limit_to
      alias_method :range, :limit_to
      
      def initialize(prop, limit_to, options = {})
        @limit_to = limit_to
        @property = prop
        
        initialize_processor(options)
      end

      def process_single(message)
        val = message.send(@property)
        if @limit_to.kind_of?(Range)
          message.send("#{@property}=", @limit_to.min) if val < @limit_to.min
          message.send("#{@property}=", @limit_to.max) if val > @limit_to.max
        elsif @limit_to.kind_of?(Numeric)
          message.send("#{@property}=", @limit_to)
        end
        message
      end

    end

  end
  
end