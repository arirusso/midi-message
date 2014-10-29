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
      processed_data = options[:const].nil? ? data : data_with_const(data, options[:const])
      initialize_channel_message(self.class.type_for_status, *processed_data)
    end

    def initialize_properties
      props = [
        { :name => :status, :index => 1 },
        { :name => :data, :index => 0 },
        { :name => :data, :index => 1 }
      ]
      properties = self.class.properties
      unless properties.nil?
        properties.each_with_index do |prop,i|
          self.class.send(:attr_reader, prop)
          self.class.send(:define_method, "#{prop}=") do |val|
            send(:instance_variable_set, "@#{prop.to_s}", val)
            send(props[i][:name])[props[i][:index]] = val
            update
            return self
          end
          instance_variable_set("@#{prop}", send(props[i][:name])[props[i][:index]])
        end
      end
    end

    protected

    def self.included(base)
      base.send(:include, ShortMessage)
      base.send(:extend, ClassMethods)
    end

    private

    def data_with_const(data, const)
      key = self.class.constant_property
      ind = self.class.properties.index(key) || 0
      data.insert(ind, const.value)
    end

    def initialize_channel_message(status_nibble_1, status_nibble_2, data_byte_1, data_byte_2 = 0)
      @status = [status_nibble_1, status_nibble_2]
      @data = [data_byte_1]
      @data[1] = data_byte_2 if self.class.second_data_byte?
      initialize_properties
      initialize_short_message(status_nibble_1, status_nibble_2)
    end

    # For defining Channel Message class types
    module ClassMethods

      # Get the status nibble for this particular message type
      # @return [Fixnum] The status nibble
      def type_for_status
        Constant::Status[display_name]
      end

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
