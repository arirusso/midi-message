#!/usr/bin/env ruby

module MIDIMessage

  module Process

    module Processor
      
      def self.included(base)
        base.extend(ClassMethods)
        base.send(:attr_reader, :name)
      end
      
      def process(messages = nil)
        messages = @message unless @message.nil?
        result = [messages].flatten.map { |message| process_single(message) }
        result.kind_of?(Array) && result.size == 1 ? result.first : result
      end

      module ClassMethods
        
        def process(msg, *a, &block)
          new(*a).process(msg, &block)
        end
        
      end

      private

      def initialize_processor(options)
        @message = options[:message]
        @name = options[:name]
      end

    end

  end
  
end