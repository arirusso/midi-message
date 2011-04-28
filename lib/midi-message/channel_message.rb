#!/usr/bin/env ruby
#
# this file contains MIDI Channel Messages
#
module MIDIMessenger

    # common behavior amongst Channel Message types
    module ChannelMessage

      attr_accessor :status_nibble_2,
                  :data_byte_1,
                  :data_byte_2
                  
      def initialize_channel_message(status_nibble_1, status_nibble_2, data_byte_1, data_byte_2 = 0)
        @status_nibble_1 = status_nibble_1
        @status_nibble_2 = status_nibble_2
        @data_byte_1 = data_byte_1
        @data_byte_2 = data_byte_2 if has_2_data_bytes?
      end

      def to_a
        db2 = has_2_data_bytes? ? @data_byte_2 : nil
        [@status_nibble_1 + @status_nibble_2, @data_byte_1, db2].compact
      end

      alias_method :to_byte_array, :to_a

      def has_2_data_bytes?
        self.class::NumDataBytes.eql?(2)
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

        # this will map friendly property names to :status, :one and :two
        # for instance, if the class calls "schema :channel, :note, :velocity"
        # aliases will be created mapping :status->:channel
        def schema(*args)
          i = 0
          props = [:status_nibble_2, :data_byte_1, :data_byte_2]
          props.each do |prop|
            unless args[i].nil?
              alias_method(args[i], prop)
              alias_method("#{args[i]}=", "#{prop.to_s}=")
            i += 1
            end
          end
          const_set("NumDataBytes", i-1)
        end

        alias_method :layout, :schema

        # this returns a hash with :remaining_hex_digits and :object
        def create_from_bytestr(hex_digits)
          data = []
          self::NumDataBytes.times { |i| data << hex_digits.slice!(2,2).hex }
          hex_digits.slice!(0,1)
          object = new(hex_digits.slice!(0,1).hex, *data)
          { :object => object, :remaining_hex_digits => hex_digits }
        end
        
        

      end
      
          # use this if you want to instantiate a raw (non sysex) midi message
    #
    # example = Raw.new(0x9, 0x0, 0x40, 0x57) # creates a raw note-on message
    #
    class Raw

      include ChannelMessage
      
      def initialize(*a)
        initialize_channel_message(*a)
      end

      # converts the raw message object in to a specific message type object
      def to_type
        MIDIMessenger::Message.create_from_hex_string(to_hex_s)
      end

    end


    end

    #
    # MIDI Channel Aftertouch message
    #
    class ChannelAftertouch

      include ChannelMessage

      schema :channel, :value
      type_id 0xD

    end

    #
    # MIDI Control Change message
    #
    class ControlChange

      include ChannelMessage

      schema :channel, :number, :value
      type_id 0xB

    end

    #
    # MIDI Note-Off message
    #
    class NoteOff

      include ChannelMessage

      schema :channel, :note, :velocity
      type_id 0x8

    end

    #
    # MIDI Note-On message
    #
    class NoteOn

      include ChannelMessage

      schema :channel, :note, :velocity
      type_id 0x9

    end

    #
    # MIDI Pitch Bend message
    #
    class PitchBend

      include ChannelMessage

      schema :channel, :low, :high
      type_id 0xE

    end

    #
    # MIDI Polyphonic (note specific) Aftertouch message
    #
    class PolyphonicAftertouch

      include ChannelMessage

      schema :channel, :note, :value
      type_id 0xA

    end

    #
    # MIDI Program Change message
    #
    class ProgramChange

      include ChannelMessage

      schema :channel, :program
      type_id 0xC

    end
    
end