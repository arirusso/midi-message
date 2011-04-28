#!/usr/bin/env ruby
#
# MIDI Channel Messages
#
module MIDIMessage

    # common behavior amongst Channel Message types
    module ChannelMessageBehavior

      attr_accessor :data
      attr_accessor :status
                  
      def initialize_channel_message(status_nibble_1, status_nibble_2, data_byte_1, data_byte_2 = 0)
	@data = []
	@status = []
        @status[0] = status_nibble_1
        @status[1] = status_nibble_2
        @data[0] = data_byte_1
        @data[1] = data_byte_2 if has_second_data_byte?
	initialize_shortcuts
      end

      def to_a
        db2 = has_second_data_byte? ? @data[1] : nil
        [@status[0] + @status[1], @data[0], db2].compact
      end

      alias_method :to_byte_array, :to_a

      def has_second_data_byte?
	!self.class::NumDataBytes.nil? && self.class::NumDataBytes > 1
      end

      def to_hex_s
        to_a.join
      end

      def initialize(*a)
        initialize_channel_message(self.class::TypeId, *a)
      end

      def self.included(base)
        base.extend(ClassMethods)
      end

      module ClassMethods

        def type_for_status
          0 + (const_get('TypeId') << 4)
        end

        def type_id(id)
          const_set("TypeId", id)
        end

        def schema(*args)
          self.send(:const_set, :Shortcuts, args)
          const_set(:NumDataBytes, args.length-1)
        end

        alias_method :layout, :schema

        # this returns a hash with :remaining_hex_digits and :object
        def new_from_bytestr(hex_digits)
          data = []
          self::NumDataBytes.times { |i| data << hex_digits.slice!(2,2).hex }
          hex_digits.slice!(0,1)
          object = new(hex_digits.slice!(0,1).hex, *data)
          { :object => object, :remaining_hex_digits => hex_digits }
        end
        
        

      end

      def initialize_shortcuts
         props = [
           { :name => :status, :index => 1 }, 
           { :name => :data, :index => 0 },
           { :name => :data, :index => 1 }
         ]
	 shortcuts = self.class.send(:const_get, :Shortcuts)
	 shortcuts.each_with_index do |prop,i|
	   self.class.send(:define_method, "#{prop}=") do |val| 
	     send(:instance_variable_set, "@#{prop.to_s}", val)
             send(props[i][:name])[props[i][:index]] = val
	   end	 	
           instance_variable_set("@#{prop}", send(props[i][:name])[props[i][:index]])
         end

      end

    end

    # use this if you want to instantiate a raw channel message
    #
    # example = ChannelMessage.new(0x9, 0x0, 0x40, 0x57) # creates a raw note-on message
    #
    class ChannelMessage

      include ChannelMessageBehavior
      
      def initialize(*a)
        initialize_channel_message(*a)
      end

    end

    #
    # MIDI Channel Aftertouch message
    #
    class ChannelAftertouch

      include ChannelMessageBehavior

      schema :channel, :value
      type_id 0xD

    end

    #
    # MIDI Control Change message
    #
    class ControlChange

      include ChannelMessageBehavior

      schema :channel, :number, :value
      type_id 0xB

    end

    #
    # MIDI Note-Off message
    #
    class NoteOff

      include ChannelMessageBehavior

      schema :channel, :note, :velocity
      type_id 0x8

    end

    #
    # MIDI Note-On message
    #
    class NoteOn

      include ChannelMessageBehavior

      schema :channel, :note, :velocity
      type_id 0x9

    end

    #
    # MIDI Pitch Bend message
    #
    class PitchBend

      include ChannelMessageBehavior

      schema :channel, :low, :high
      type_id 0xE

    end

    #
    # MIDI Polyphonic (note specific) Aftertouch message
    #
    class PolyphonicAftertouch

      include ChannelMessageBehavior

      schema :channel, :note, :value
      type_id 0xA

    end

    #
    # MIDI Program Change message
    #
    class ProgramChange

      include ChannelMessageBehavior

      schema :channel, :program
      type_id 0xC

    end
    
end
