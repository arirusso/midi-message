#!/usr/bin/env ruby
#
module MIDIMessage

    # common behavior amongst all Message types
    module SimpleMessageBehavior

      attr_reader :name,
                  :status,
                  :verbose_name

      def initialize_simple_message(status_nibble_1, status_nibble_2)
	      @status = [status_nibble_1, status_nibble_2]
        const = Constant[self.class::DisplayName].find { |k,v| k if v.eql?(@status[1]) }
        unless const.nil?
          @name = const.first
          @verbose_name = "#{self.class::DisplayName}: #{const.first}"
        end
      end

      def to_hex_s
        to_a.join
      end
      alias_method :hex, :to_hex_s

    end

end
