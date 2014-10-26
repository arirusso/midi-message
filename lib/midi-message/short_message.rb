module MIDIMessage

  # Common behavior amongst all Message types
  module ShortMessage

    include MIDIMessage # this enables ..kind_of?(MIDIMessage)
    
    attr_reader :name,
                :status,
                :verbose_name

    # Initialize the message status
    # @param [Fixnum] status_nibble_1 The first nibble of the status
    # @param [Fixnum] status_nibble_2 The second nibble of the status
    def initialize_short_message(status_nibble_1, status_nibble_2)
      @status = [status_nibble_1, status_nibble_2]
      populate_using_const
    end

    # Byte array representation of the message eg [0x90, 0x40, 0x40] for NoteOn(0x40, 0x40)
    # @return [Array<Fixnum>] The array of bytes in the MIDI message
    def to_a
      data = @data.nil? ? [] : [@data[0], @data[1]]
      [(@status[0] << 4) + @status[1], *data].compact
    end
    alias_method :to_byte_a, :to_a
    alias_method :to_byte_array, :to_a
    alias_method :to_bytes, :to_a

    # String representation of the message's bytes eg "904040" for NoteOn(0x40, 0x40)
    # @return [String] The bytes of the message as a string of hex bytes
    def to_hex_s
      TypeConversion.numeric_byte_array_to_hex_string(to_a)
    end
    alias_method :to_bytestr, :to_hex_s

    protected

    def self.included(base)
      base.send(:extend, ClassMethods)
    end

    def update
      populate_using_const
    end

    private

    # This will populate message metadata with information gathered from midi.yml
    def populate_using_const
      const_group_name = self.class.display_name
      group_name_alias = self.class.constant_name
      property = self.class.constant_property
      value = self.send(property) unless property.nil?
      value ||= @status[1] # default property to use for constants
      group = ConstantGroup[group_name_alias] || ConstantGroup[const_group_name]
      unless group.nil?
        const = group.find_by_value(value)
        unless const.nil?
          @const = const
          @name = @const.nil? ? const.key : @const.key
          @verbose_name = "#{self.class.display_name}: #{@name}"
        end
      end
    end

    module ClassMethods

      # Find a constant value in this class's group for the passed in key
      # @param [String] name The constant key
      # @return [String] The constant value
      def get_constant(name)
        key = constant_name || display_name
        unless key.nil?
          group = ConstantGroup[key]
          group.find(name)
        end
      end

      def display_name
        const_get("DISPLAY_NAME") if const_defined?("DISPLAY_NAME")
      end

      def constant_map
        const_get("CONSTANT") if const_defined?("CONSTANT")
      end

      def constant_name
        constant_map.keys.first unless constant_map.nil?
      end

      def constant_property
        constant_map[constant_name] unless constant_map.nil?
      end

      # This returns a MessageBuilder for the class, preloaded with the selected const
      # @param [String, Symbol] const_name The constant key to use to build the message
      # @return [MIDIMessage::MessageBuilder] A MessageBuilder object for the passed in constant
      def [](const_name)
        const = get_constant(const_name.to_s)
        MessageBuilder.new(self, const) unless const.nil?
      end

    end

  end

  class MessageBuilder

    # @param [MIDIMessage] klass The message class to build
    # @param [String] const The constant to build the message with
    def initialize(klass, const)
      @klass = klass
      @const = const
    end

    def new(*a)
      a.last.kind_of?(Hash) ? a.last[:const] = @const : a.push(:const => @const)
      @klass.new(*a)
    end

  end

  # Shortcuts for dealing with message status
  module Status

    # The value of the Status constant with the name status_name
    # @param [String] status_name The key to use to look up a constant value
    # @return [String] The constant value that was looked up
    def self.[](status_name)
      const = Constant.find("Status", status_name)
      const.value unless const.nil?
    end

  end

end
