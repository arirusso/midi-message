module MIDIMessage

  # Common behavior amongst Channel Message types
  module ChannelMessage

    include MIDIMessage # this enables ..kind_of?(MIDIMessage)

    attr_reader :data, :name

    # Shortcut to RawChannelMessage.new
    # aka build a ChannelMessage from raw nibbles and bytes
    # eg ChannelMessage.new(0x9, 0x0, 0x40, 0x40)
    # @param [*Array<Fixnum>] data The status nibbles and data bytes
    # @return [RawChannelMessage] The resulting RawChannelMessage object
    def self.new(*data, &block)
      Message.new(*data, &block)
    end

    # @param [*Array<Fixnum>] data The status nibbles and data bytes
    def initialize(*data)
      data = data.dup
      options = data.last.kind_of?(Hash) ? data.pop : {}
      add_constant_value(options[:const], data) unless options[:const].nil?
      initialize_channel_message(self.class.type_for_status, *data)
    end

    # Decorates the object with the particular properties for its type
    # @return [Boolean]
    def initialize_properties
      properties = self.class.properties
      add_properties(properties) unless properties.nil?
    end

    private

    def self.included(base)
      base.send(:include, ::MIDIMessage::Message)
      base.send(:extend, ClassMethods)
    end

    def add_constant_value(constant, data)
      index = Constant::Loader.get_index(self)
      data.insert(index, constant.value)
    end

    # @param [Array<Symbol>] properties
    # @return [Boolean]
    def add_properties(properties)
      has_properties = false
      schema = [
        { :name => :status, :index => 1 }, # second status nibble
        { :name => :data, :index => 0 }, # first data byte
        { :name => :data, :index => 1 } # second data byte
      ]
      properties.each_with_index do |property, i|
        property_schema = schema[i]
        define_getter(property, property_schema)
        define_setter(property, property_schema)
        has_properties = true
      end
      has_properties
    end

    # @param [Symbol, String] property
    # @param [Hash] container
    # @param [Fixnum] index
    # @return [Boolean]
    def define_getter(property, property_schema)
      container = send(property_schema[:name])
      index = property_schema[:index]
      self.class.send(:attr_reader, property)
      instance_variable_set("@#{property.to_s}", container[index])
      true
    end

    # @param [Symbol, String] property
    # @param [Hash] container
    # @param [Fixnum] index
    # @return [Boolean]
    def define_setter(property, property_schema)
      index = property_schema[:index]
      self.class.send(:define_method, "#{property.to_s}=") do |value|
        send(:instance_variable_set, "@#{property.to_s}", value)
        send(property_schema[:name])[index] = value
        update
        return self
      end
      true
    end

    def initialize_channel_message(status_nibble_1, status_nibble_2, data_byte_1, data_byte_2 = 0)
      @status = [status_nibble_1, status_nibble_2]
      @data = [data_byte_1]
      @data[1] = data_byte_2 if self.class.second_data_byte?
      initialize_properties
      initialize_message(status_nibble_1, status_nibble_2)
    end

    # For defining Channel Message class types
    module ClassMethods

      def properties
        const_get("DATA") if const_defined?("DATA")
      end

      # Does the schema of this Channel Message carry a second data byte?
      # eg. NoteMessage does, and ProgramChange doesn"t
      # @return [Boolean] Is there a second data byte on this message type?
      def second_data_byte?
        properties.nil? || (properties.length-1) > 1
      end

    end

    # Use this if you want to instantiate a raw channel message
    #
    # For example ChannelMessage::Message.new(0x9, 0x0, 0x40, 0x57)
    # creates a raw note-on message
    class Message

      include ChannelMessage

      DISPLAY_NAME = "Channel Message"

      # Build a Channel Mssage from raw nibbles and bytes
      # eg ChannelMessage.new(0x9, 0x0, 0x40, 0x40)
      # @param [*Array<Fixnum>] data The status nibbles and data bytes
      # @return [RawChannelMessage] The resulting RawChannelMessage object
      def initialize(*data)
        initialize_channel_message(*data)
      end

      # Convert this RawChannelMessage to one of the more specific ChannelMessage types
      # eg. RawChannelMessage.new(0x9, 0x0, 0x40, 0x40).to_type would result in
      # NoteMessage.new(0x0, 0x40, 0x40)
      # @return [ChannelMessage] The resulting specific ChannelMessage object
      def to_type
        status = (@status[0] << 4) + (@status[1])
        MIDIMessage.parse(status, *@data)
      end

    end

  end

end
