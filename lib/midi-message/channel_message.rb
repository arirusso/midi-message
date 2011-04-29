#!/usr/bin/env ruby
#
module MIDIMessage

    # common behavior amongst Channel Message types
    module ChannelMessageBehavior

      attr_reader :data,
                  :name,
                  :status
                  
      def initialize_channel_message(status_nibble_1, status_nibble_2, data_byte_1, data_byte_2 = 0)
        @status = [status_nibble_1, status_nibble_2]
        @data = [data_byte_1]
        @data[1] = data_byte_2 if self.class::second_data_byte?
        initialize_shortcuts
        initialize_simple_message(status_nibble_1, status_nibble_2)
      end

      def to_a
        db2 = self.class::second_data_byte? ? @data[1] : nil
        [@status[0] + @status[1], @data[0], db2].compact
      end
      alias_method :to_byte_array, :to_a
      alias_method :to_bytes, :to_a

      def to_hex_s
        to_a.join
      end
      alias_method :hex, :to_hex_s

      def initialize(*a)
        initialize_channel_message(self.class::TypeId, *a)
      end

      def self.included(base)
        base.extend(ClassMethods)
      end

      module ClassMethods

        def type_for_status
          0 + (const_get(:TypeId) << 4)
        end

        def type_id(id)
          const_set(:TypeId, id)
        end

        def schema(*args)
          self.send(:const_set, :Shortcuts, args)
          const_set(:NumDataBytes, args.length-1)
        end
        alias_method :layout, :schema

        def second_data_byte?
          num = const_get(:NumDataBytes)
          !num.nil? && num > 1
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
           self.class.send(:attr_reader, prop)
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

      include SimpleMessageBehavior
      include ChannelMessageBehavior

      display_name 'Channel Message'
      
      def initialize(*a)
        initialize_channel_message(*a)
      end

    end

    #
    # MIDI Channel Aftertouch message
    #
    class ChannelAftertouch

      include SimpleMessageBehavior
      include ChannelMessageBehavior

      schema :channel, :value
      type_id 0xD
      display_name 'Channel Aftertouch'

    end

    #
    # MIDI Control Change message
    #
    class ControlChange

      include SimpleMessageBehavior
      include ChannelMessageBehavior

      schema :channel, :number, :value
      type_id 0xB
      display_name 'Control Change'
      identifier :number

    end

    #
    # MIDI Note-Off message
    #
    class NoteOff

      include SimpleMessageBehavior
      include ChannelMessageBehavior

      schema :channel, :note, :velocity
      type_id 0x8
      display_name 'Note Off'
      use_constants 'Note'
      identifier :note

    end

    #
    # MIDI Note-On message
    #
    class NoteOn

      include SimpleMessageBehavior
      include ChannelMessageBehavior

      schema :channel, :note, :velocity
      type_id 0x9
      display_name 'Note On'
      use_constants 'Note'
      identifier :note

    end

    #
    # MIDI Pitch Bend message
    #
    class PitchBend

      include SimpleMessageBehavior
      include ChannelMessageBehavior

      schema :channel, :low, :high
      type_id 0xE
      DisplayName = 'Pitch Bend'

    end

    #
    # MIDI Polyphonic (note specific) Aftertouch message
    #
    class PolyphonicAftertouch

      include SimpleMessageBehavior
      include ChannelMessageBehavior

      schema :channel, :note, :value
      type_id 0xA
      DisplayName = 'Polyphonic Aftertouch'

    end

    #
    # MIDI Program Change message
    #
    class ProgramChange

      include SimpleMessageBehavior
      include ChannelMessageBehavior

      schema :channel, :program
      type_id 0xC
      DisplayName = 'Program Change'

    end
    
end
