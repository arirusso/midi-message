#!/usr/bin/env ruby

module MIDIMessage

  module Process
    
    class Transpose

      include Processor

      attr_reader :factor, :property
      
      def initialize(message, prop, factor, options = {})
        @factor = factor
        @message = message
        @property = prop
        initialize_processor(message)
      end

      def process
        val = @message.send(@property)
        @message.send("#{@property}=", val + @factor)
        @message
      end

    end

  end
  
end