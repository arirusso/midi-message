#!/usr/bin/env ruby
#
# (c)2011 Ari Russo and licensed under the Apache 2.0 License
#

module MIDIMessage

  # MIDI System-Exclusive Messages (SysEx)
  module SystemExclusive

    # basic SysEx data that a message class will contain
    module Base

      attr_accessor :node
      attr_reader :address,
                  :checksum

      StartByte = 0xF0
      EndByte = 0xF7
      
      # an array of message parts.  multiple byte parts will be represented as an array of bytes
      def to_a
        array
      end

      # a flat array of message bytes
      def to_byte_array
        array.flatten
      end

      def status_byte
        StatusByte
      end
      
      private

      def address_to_i
        address.inject { |a,b| a + b }
      end

      def value_to_i
        value.kind_of?(Array) ? value.inject { |a,b| a + b } : value
      end

      def initialize_sysex(address, options = {})
        @node = options[:node]
        @checksum = options[:checksum]
        @address = address
      end

      def array
        # this may need to be cached when properties are updated
        # might be worth benchmarking
        @checksum = (128 - (address_to_i + value_to_i).divmod(128)[1])
        [
          StartByte,
          @node.manufacturer,
          @node.device_id, # (@device_id || @node.device_id) ?? dunno
          @node.model_id,
          status_byte,
          [address].flatten,
          [value].flatten,
          @checksum,
          EndByte
        ]
      end

    end

    # A SysEx command message
    # a command message is identified by having a status byte equal to 0x12
    #
    class Command

      include Base

      attr_reader :data
      alias_method :value, :data
      #alias_method :value=, :data=

      StatusByte = 0x12
      
      def initialize(address, data, options = {})
        @data = data
        initialize_sysex(address, options)
      end
      
    end

    #
    # The SystemExclusive::Node represents a destination for a message.  For example a hardware 
    # synthesizer or sampler
    #
    class Node

      attr_accessor :device_id
      attr_reader :manufacturer, :model_id
      
      def initialize(manufacturer, model_id, options = {})
        @device_id = options[:device_id]
        @model_id = model_id
        @manufacturer = manufacturer
      end

      # this message takes a prototype message, copies it, and returns the copy with its node set
      # to this node
      def new_message_from(prototype_message)
        copy = prototype_message.clone
        copy.node = self
        copy
      end
      
      # create a new Command message associated with this node
      def command(*a)
        command = Command.new(*a)
        command.node = self
        command
      end
      
      # create a new Request message associated with this node
      def request(*a)
        request = Request.new(*a)
        request.node = self
        request
      end

    end

    # A SysEx request message
    # A request message is identified by having a status byte equal to 0x11
    #
    class Request

      include Base

      attr_reader :size
      alias_method :value, :size
      #alias_method :value=, :size=

      StatusByte = 0x11
      
      def initialize(address, size, options = {})
        @size = size
        initialize_sysex(address, options = {})
      end
      
    end

    # convert raw MIDI data to SysEx message objects
    def self.new(*bytes)

      start_status = bytes.shift
      end_status = bytes.pop

      return nil unless start_status.eql?(0xF0) && end_status.eql?(0xF7)

      fixed_length_message_part = bytes.slice!(0,7)

      manufacturer_id = fixed_length_message_part[0]
      device_id = fixed_length_message_part[1]
      model_id = fixed_length_message_part[2]

      msg_class = case fixed_length_message_part[3]
        when 0x11 then Request
        when 0x12 then Command
      end

      address = fixed_length_message_part.slice(4,3)
      checksum = bytes.slice!((bytes.length - 1), 1)
      value = bytes

      node = Node.new(manufacturer_id, model_id, :device_id => device_id)
      msg_class.new(address, value, :checksum => checksum, :node => node)
    end

  end

end