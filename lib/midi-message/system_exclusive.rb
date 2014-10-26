module MIDIMessage

  # MIDI System-Exclusive Messages (SysEx)
  module SystemExclusive

    include MIDIMessage # this enables ..kind_of?(MIDIMessage)
    
    def self.included(base)
      base.send(:include, InstanceMethods)
    end

    # Common SysEx data that a message class will contain
    module InstanceMethods

      attr_accessor :node
      attr_reader :address, :checksum

      StartByte = 0xF0
      EndByte = 0xF7

      # an array of message parts.  multiple byte parts will be represented as an array of bytes
      def to_a(options = {})
        omit = options[:omit] || []
        node = @node.to_a(options) unless @node.nil? || omit.include?(:node)
        # this may need to be cached when properties are updated
        # might be worth benchmarking
        [
          start_byte,
          node,
          (type_byte unless omit.include?(:type)),
          [address].compact.flatten,
          [value].compact.flatten,
          (checksum unless omit.include?(:checksum)),
          end_byte
        ].compact
      end

      # a flat array of message bytes
      def to_numeric_byte_array(options = {})
        to_a(options).flatten
      end
      alias_method :to_numeric_bytes, :to_numeric_byte_array
      alias_method :to_byte_array, :to_numeric_byte_array
      alias_method :to_bytes, :to_numeric_byte_array
      alias_method :to_byte_a, :to_numeric_byte_array

      # string representation of the object's bytes
      def to_hex_s
        strings = to_bytes.map do |byte|
          string = byte.to_s(16)
          string = "0#{string}" if string.length == 1
          string
        end
        strings.join.upcase
      end
      alias_method :to_bytestr, :to_hex_s

      def name
        "System Exclusive"
      end
      alias_method :verbose_name, :name

      def start_byte
        self.class::StartByte
      end

      def end_byte
        self.class::EndByte
      end

      def type_byte
        self.class::TypeByte
      end

      # alternate method from
      # http://www.2writers.com/eddie/TutSysEx.htm
      def checksum
        sum = (address + [value].flatten).inject(&:+)
        mod = sum.divmod(128)[1]
        128 - mod
      end

      private

      def initialize_sysex(address, options = {})
        @node = options[:node]
        @checksum = options[:checksum]
        @address = address
      end

    end

    # A SysEx message with no implied type
    #
    class Message

      include InstanceMethods

      attr_accessor :data

      def initialize(data, options = {})
        @data = if data.kind_of?(Array) && data.length == 1
          data.first
        else
          data
        end
        initialize_sysex(nil, options)
      end

      # an array of message parts.  multiple byte parts will be represented as an array of bytes
      def to_a(options = {})
        omit = options[:omit] || []
        node = @node.to_a(options) unless @node.nil? || omit.include?(:node)
        # this may need to be cached when properties are updated
        # might be worth benchmarking
        [
          start_byte,
          node,
          @data,
          end_byte
        ].compact
      end

    end

    #
    # The SystemExclusive::Node represents a destination for a message.  For example a hardware
    # synthesizer or sampler
    #
    class Node

      attr_accessor :device_id
      attr_reader :manufacturer_id, :model_id

      def initialize(manufacturer, options = {})
        @device_id = options[:device_id]
        @model_id = options[:model_id]
        @manufacturer_id = get_manufacturer_id(manufacturer)
      end

      def to_a(options = {})
        omit = options[:omit] || []
        properties = [:manufacturer, :device, :model].map do |property|
          unless omit.include?(property) || omit.include?("#{property.to_s}_id")
            instance_variable_get("@#{property.to_s}_id")
          end
        end
        properties.compact
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

      private

      def get_manufacturer_id(manufacturer)
        if manufacturer.kind_of?(Numeric)
          manufacturer
        else
          const = Constant.find("Manufacturer", manufacturer)
          const.value
        end
      end

    end

    # Convert raw MIDI data to SysEx message objects
    def self.new(*bytes)

      start_status = bytes.shift
      end_status = bytes.pop

      if start_status == 0xF0 && end_status == 0xF7

        type_byte = bytes[3]

        # if the 4th byte isn't status, we will just make this a Message object -- this may need some tweaking
        if type_byte == 0x11
          msg_class = Request
        elsif type_byte == 0x12
          msg_class = Command
        else
          return Message.new(bytes)
        end

        fixed_length_message_part = bytes.slice!(0,7)

        manufacturer_id = fixed_length_message_part[0]
        device_id = fixed_length_message_part[1]
        model_id = fixed_length_message_part[2]

        address = fixed_length_message_part.slice(4,3)
        checksum = bytes.slice!((bytes.length - 1), 1)
        value = bytes

        node = Node.new(manufacturer_id, :model_id => model_id, :device_id => device_id)
        msg_class.new(address, value, :checksum => checksum, :node => node)
      end
    end

  end

end
