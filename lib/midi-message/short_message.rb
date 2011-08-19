#!/usr/bin/env ruby
#

module MIDIMessage

  # common behavior amongst all Message types
  module ShortMessage

    attr_reader :name,
                :status,
                :verbose_name
                  
    def initialize_short_message(status_nibble_1, status_nibble_2)
      @status = [status_nibble_1, status_nibble_2]
      populate_using_const
    end
    
    # byte array representation of the object eg [0x90, 0x40, 0x40] for NoteOn(0x40, 0x40)
    def to_a
      data = @data.nil? ? [] : [@data[0], @data[1]] 
      [(@status[0] << 4) + @status[1], *data].compact
    end
    alias_method :to_byte_a, :to_a
    alias_method :to_byte_array, :to_a
    alias_method :to_bytes, :to_a

    # string representation of the object's bytes eg "904040" for NoteOn(0x40, 0x40)
    def to_hex_s
      TypeConversion.numeric_byte_array_to_hex_string(to_a)
    end
    alias_method :to_bytestr, :to_hex_s
    
    protected
    
    def self.included(base)
      base.extend(ClassMethods)
    end
    
    def update
      populate_using_const
    end
    
    private
    
    # this will populate message metadata with information gathered from midi.yml
    def populate_using_const
      const_group_name = self.class.display_name
      group_name_alias = self.class.constants
      prop = self.class.map_constants_to
      val = self.send(prop) unless prop.nil?
      val ||= @status[1] # default property to use for constants
      group = ConstantGroup[group_name_alias] || ConstantGroup[const_group_name]
      unless group.nil?
        const = group.find_by_value(val)
        unless const.nil?
          @const = const
          @name = @const.nil? ? const.key : @const.key
          @verbose_name = "#{self.class.display_name}: #{@name}"          
        end
      end      
    end

    module ClassMethods
      
      attr_reader :display_name, :constants, :map_constants_to 
      
      def get_constant(name)        
        key = @constants || @display_name
        unless key.nil?
          group = ConstantGroup[key]
          group.find(name)
        end 
      end

      # this returns a builder for the class, preloaded with the selected const
      def [](const_name)
        const = get_constant(const_name)
        MessageBuilder.new(self, const) unless const.nil?
      end
      
      def use_display_name(name)
        @display_name = name
      end

      def use_constants(name, options = {}) 
        @map_constants_to = options[:for]
        @constants = name
      end

    end

  end

  class MessageBuilder

    def initialize(klass, const)      
      @klass = klass      
      @const = const
    end

    def new(*a)    
      a.last.kind_of?(Hash) ? a.last[:const] = @const : a.push(:const => @const)         
      @klass.new(*a)
    end

  end
  
  # shortcuts for dealing with message status
  module Status
    
    # this returns the value of the Status constant with the name status_name
    def self.[](status_name)
      const = Constant.find("Status", status_name)
      const.value unless const.nil?
    end    
    
  end

end
