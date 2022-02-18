# frozen_string_literal: true

module MIDIMessage
  # Refer to a MIDI message by its usage
  # eg *C4* for MIDI note *60* or *Bank Select* for MIDI control change *0*
  module Constant
    # Get a Mapping object for the specified constant
    # @param [Symbol, String] group_name
    # @param [String] const_name
    # @return [MIDIMessage::Constant::Map, nil]
    def self.find(group_name, const_name)
      group = Group[group_name]
      group.find(const_name)
    end

    # Get the value of the specified constant
    # @param [Symbol, String] group_name
    # @param [String] const_name
    # @return [Object]
    def self.value(group_name, const_name)
      map = find(group_name, const_name)
      map.value
    end

    module Name
      module_function

      # eg "Control Change" -> "control_change"
      # @param [Symbol, String] string
      # @return [String]
      def underscore(string)
        string.to_s.downcase.gsub(/(\ )+/, '_')
      end

      # @param [Symbol, String] key
      # @param [Symbol, String] other
      # @return [Boolean]
      def match?(key, other)
        match_key = key.to_s.downcase
        [match_key, Name.underscore(match_key)].include?(other.to_s.downcase)
      end
    end

    # MIDI Constant container
    class Group
      attr_reader :constants, :key

      # @param [String] key
      # @param [Hash] constants
      def initialize(key, constants)
        @key = key
        @constants = constants.map { |k, v| Constant::Map.new(k, v) }
      end

      # Find a constant by its name
      # @param [String, Symbol] name
      # @return [Constant::Map]
      def find(name)
        @constants.find { |const| Name.match?(const.key, name) }
      end

      # Find a constant by its value
      # @param [Object] value
      # @return [Constant::Map]
      def find_by_value(value)
        @constants.find { |const| Name.match?(const.value, value) }
      end

      class << self
        # All constant groups
        # @return [Array<ConstantGroup>]
        def all
          ensure_initialized
          @groups
        end

        # Find a constant group by its key
        # @param [String, Symbol] key
        # @return [ConstantGroup]
        def find(key)
          ensure_initialized
          @groups.find { |group| Name.match?(group.key, key) }
        end
        alias [] find

        private

        # Lazy initialize
        # @return [Boolean]
        def ensure_initialized
          @dict = nil
          @groups = nil
          populate_dictionary | populate_groups
        end

        # Populate the dictionary of constants
        # @return [Boolean]
        def populate_dictionary
          if @dict.nil?
            file = File.expand_path('../midi.yml', __dir__)
            @dict = YAML.load_file(file)
            @dict.freeze
            true
          end
        end

        # Populate the constant groups using the dictionary
        # @return [Boolean]
        def populate_groups
          if @groups.nil? && !@dict.nil?
            @groups = @dict.map { |k, v| new(k, v) }
            true
          end
        end
      end
    end

    # The mapping of a constant key to its value eg "Note On" => 0x9
    class Map
      attr_reader :key, :value

      # @param [String] key
      # @param [Object] value
      def initialize(key, value)
        @key = key
        @value = value
      end
    end

    class MessageBuilder
      # @param [MIDIMessage] klass The message class to build
      # @param [MIDIMessage::Constant::Map] const The constant to build the message with
      def initialize(klass, const)
        @klass = klass
        @const = const
      end

      # @param [*Object] args
      # @return [Message]
      def new(*args)
        args = args.dup
        args.last.kind_of?(Hash) ? args.last[:const] = @const : args.push(const: @const)
        @klass.new(*args)
      end
    end

    # Shortcuts for dealing with message status
    module Status
      class << self
        # The value of the Status constant with the name status_name
        # @param [String] status_name The key to use to look up a constant value
        # @return [String] The constant value that was looked up
        def find(status_name)
          const = Constant.find('Status', status_name)
          const&.value
        end
        alias [] find
      end
    end

    # Loading constants from the spec file into messages
    module Loader
      module_function

      # Get the index of the constant from the given message's type
      # @param [Message] message
      # @return [Fixnum]
      def get_index(message)
        key = message.class.constant_property
        message.class.properties.index(key) || 0
      end

      # Used to populate message metadata with information gathered from midi.yml
      # @param [Message] message
      # @return [Hash, nil]
      def get_info(message)
        const_group_name = message.class.display_name
        group_name_alias = message.class.constant_name
        property = message.class.constant_property
        value = message.send(property) unless property.nil?
        value ||= message.status[1] # default property to use for constants
        group = Constant::Group[group_name_alias] || Constant::Group[const_group_name]
        if !group.nil? && !(const = group.find_by_value(value)).nil?
          {
            const: const,
            name: const.key,
            verbose_name: "#{message.class.display_name}: #{const.key}"
          }
        end
      end

      # DSL type class methods for loading constants into messages
      module DSL
        # Find a constant value in this class's group for the passed in key
        # @param [String] name The constant key
        # @return [String] The constant value
        def get_constant(name)
          key = constant_name || display_name
          unless key.nil?
            group = Group[key]
            group.find(name)
          end
        end

        # @return [String]
        def display_name
          const_get('DISPLAY_NAME') if const_defined?('DISPLAY_NAME')
        end

        # @return [Hash]
        def constant_map
          const_get('CONSTANT') if const_defined?('CONSTANT')
        end

        # @return [String]
        def constant_name
          constant_map&.keys&.first
        end

        # @return [Symbol]
        def constant_property
          constant_map[constant_name] unless constant_map.nil?
        end

        # Get the status nibble for this particular message type
        # @return [Fixnum] The status nibble
        def type_for_status
          Constant::Status[display_name]
        end

        # This returns a MessageBuilder for the class, preloaded with the selected const
        # @param [String, Symbol] const_name The constant key to use to build the message
        # @return [MIDIMessage::MessageBuilder] A MessageBuilder object for the passed in constant
        def find(const_name)
          const = get_constant(const_name.to_s)
          MessageBuilder.new(self, const) unless const.nil?
        end
        alias [] find
      end
    end
  end
end
