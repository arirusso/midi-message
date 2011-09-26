#!/usr/bin/env ruby

module MIDIMessage

  module Process
    
    class Transpose

      include Processor

      attr_reader :factor, :property
      
      def initialize(prop, factor, options = {})
        @factor = factor
        @property = prop
        
        initialize_processor(options)
      end

      def process_single(message)
        val = message.send(@property)
        message.send("#{@property}=", val + @factor)
        message
      end

    end

  end
  
end