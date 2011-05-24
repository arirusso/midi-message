#!/usr/bin/env ruby
#

module MIDIMessage

  # common behavior amongst all Message types
  module ShortMessageBehavior

    attr_reader :name,
                :status,
                :verbose_name
                  
    def initialize_short_message(status_nibble_1, status_nibble_2)
      @status = [status_nibble_1, status_nibble_2]
      group_name = self.class.display_name
      group_name_alias = self.class.constants
      prop = self.class.map_constants_to
      val = self.send(prop) unless prop.nil?
      val ||= @status[1] # default property to use for constants
      group = Constant[group_name] || (group_name_alias.nil? ? nil : Constant[group_name_alias])
      unless group.nil?
        const = group.find { |k,v| k if v.eql?(val) }
        unless const.nil?
          @name = const.first
          @verbose_name = "#{self.class.display_name}: #{const.first}"
        end
      end
    end

    # byte array representation of the object eg [0x90, 0x40, 0x40] for NoteOn(0x40, 0x40)
    def to_a
      data = @data.nil? ? [] : [@data[0], @data[1]] 
      [(@status[0] << 4) + @status[1], *data].compact
    end
    alias_method :to_byte_array, :to_a
    alias_method :to_bytes, :to_a

    # string representation of the object's bytes eg "904040" for NoteOn(0x40, 0x40)
    def to_hex_s
      TypeConversion.numeric_byte_array_to_hex_string(to_a)
    end
    alias_method :to_bytestr, :to_hex_s
    
    def self.included(base)
      base.extend(ClassMethods)
    end

    module ClassMethods
      
      attr_reader :display_name, :constants, :map_constants_to 
      
      def get_constant_value(name)        
        key = @constants
        key ||= @display_name
        unless key.nil?
          group = Constant.instance[key.to_s]
          match = group.find { |k,v| k.to_s.downcase.eql?(name.to_s.downcase) }               
          match.last unless match.nil?
        end 
      end

      # this returns a builder for the class, preloaded with the selected const
      def [](const_name)
        const_val = get_constant_value(const_name)
        MessageBuilder.new(self, const_val, const_name) unless const_val.nil?
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
      @const = const
      @klass = klass
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
      Constant.instance["Status"][status_name.to_s]
    end    
    
  end

end
