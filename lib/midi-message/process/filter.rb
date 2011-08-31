#!/usr/bin/env ruby

module MIDIMessage

  module Process

    # Use the Filter superclass when you need a multi-band filter
    class Filter

      include Processor

      attr_reader :bandwidth, :property, :reject
      
      def initialize(message, prop, bandwidth, options = {})
        @bandwidth = [bandwidth].flatten
        @message = message
        @property = prop
        @reject = options[:reject] || false
        initialize_processor(message)
      end

      def process
        val = @message.send(@property)
        result = @bandwidth.map { |bw| val >= bw.min && val <= bw.max ? @message : nil }
        result.include?(@message) ^ @reject ? @message : nil
      end

    end

    class LowPassFilter < Filter
      def initialize(message, prop, max, options = {})
        super(message, prop, (0..max), options)
      end
    end

    class HighPassFilter < Filter
      def initialize(message, prop, min, options = {})
        super(message, prop, (min..127), options)
      end
    end

    class BandPassFilter < Filter
      def initialize(message, prop, accept_range, options = {})
        options[:reject] = false
        super(message, prop, accept_range, options)
      end
    end

    class BandRejectFilter < Filter
      def initialize(message, prop, reject_range, options = {})
        options[:reject] = true
        super(message, prop, reject_range, options)
      end
    end
    NotchFilter = BandRejectFilter

  end
end