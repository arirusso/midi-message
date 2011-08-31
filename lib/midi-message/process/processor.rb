#!/usr/bin/env ruby

module MIDIMessage

  module Process

    module Processor
      
      def self.included(base)
        base.extend(ClassMethods)
        base.send(:attr_reader, :message)
      end

      module ClassMethods
        def process(*a, &block)
          new(*a).process(&block)
        end
      end

      private

      def initialize_processor(message)
        @message = message
      end

    end

  end
  
end