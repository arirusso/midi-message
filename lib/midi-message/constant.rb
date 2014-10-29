module MIDIMessage

  # MIDI Constants
  class ConstantGroup

    attr_reader :key, :value

    def initialize(key, constants)
      @key = key
      @constants = constants.map { |k, v| Constant.new(k, v) }
    end

    def find(name)
      @constants.find { |const| const.key.to_s.downcase == name.to_s.downcase }
    end
    alias_method :[], :find

    def find_by_value(value)
      @constants.find { |const| const.value.to_s.downcase == value.to_s.downcase }
    end

    def self.all
      ensure_initialized
      @groups
    end

    def self.[](key)
      ensure_initialized
      @groups.find { |g| g.key.to_s.downcase == key.to_s.downcase }
    end

    private

    # lazy initialize
    def self.ensure_initialized
      @dict ||= YAML.load_file(File.expand_path('../../midi.yml', __FILE__))
      @groups ||= @dict.map { |k, v| new(k, v) }
    end

  end

  class Constant

    attr_reader :key, :value

    def initialize(key, value)
      @key = key
      @value = value
    end

    def self.find(group_name, const_name)
      group = ConstantGroup[group_name]
      group.find(const_name)
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
