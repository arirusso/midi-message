#!/usr/bin/env ruby
#
module MIDIMessage

  # common behavior amongst Channel Message types
  module ChannelMessageBehavior

    attr_reader :data,
                :name
                  
    def initialize(*a)
      options = a.last.kind_of?(Hash) ? a.pop : {}
      @const = options[:const]        
      unless @const.nil?
        key = self.class.map_constants_to
        ind = self.class.properties.index(key)
        ind ||= 0
        a.insert(ind, @const.value)               
      end
      initialize_channel_message(self.class.type_for_status, *a)
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
      base.extend(ClassMethods)
    end

    private
    
    def initialize_channel_message(status_nibble_1, status_nibble_2, data_byte_1, data_byte_2 = 0)
      @status = [status_nibble_1, status_nibble_2]
      @data = [data_byte_1]
      @data[1] = data_byte_2 if self.class.second_data_byte?
      initialize_properties
      initialize_short_message(status_nibble_1, status_nibble_2)
    end
    
    module ClassMethods
      
      attr_reader :properties
            
      def type_for_status
        @display_name.nil? ? nil : Status[@display_name] 
      end

      def schema(*args)
        @properties = args
      end
      alias_method :layout, :schema

      def second_data_byte?
        @properties.nil? || (@properties.length-1) > 1
      end

    end
        
  end

  # use this if you want to instantiate a raw channel message
  #
  # example = ChannelMessage.new(0x9, 0x0, 0x40, 0x57) # creates a raw note-on message
  #
  class ChannelMessage

    include ShortMessageBehavior
    include ChannelMessageBehavior

    use_display_name 'Channel Message'
    
    def initialize(*a)
      initialize_channel_message(*a)
    end        
    
    def to_type
      status = (@status[0] << 4) + (@status[1])
      MIDIMessage.parse(status, *@data)
    end

  end

  #
  # MIDI Channel Aftertouch message
  #
  class ChannelAftertouch

    include ShortMessageBehavior
    include ChannelMessageBehavior

    schema :channel, :value
    use_display_name 'Channel Aftertouch'

  end
  ChannelPressure = ChannelAftertouch

  #
  # MIDI Control Change message
  #
  class ControlChange

    include ShortMessageBehavior
    include ChannelMessageBehavior

    schema :channel, :index, :value
    use_display_name 'Control Change'
    use_constants 'Control Change', :for => :index
   
  end  
  Controller = ControlChange #shortcut

  #
  # MIDI Note-Off message
  #
  class NoteOff

    include ShortMessageBehavior
    include ChannelMessageBehavior

    schema :channel, :note, :velocity
    use_display_name 'Note Off'
    use_constants 'Note', :for => :note

  end

  #
  # MIDI Note-On message
  #
  class NoteOn

    include ShortMessageBehavior
    include ChannelMessageBehavior

    schema :channel, :note, :velocity
    use_display_name 'Note On'
    use_constants 'Note', :for => :note
    
    # returns the NoteOff equivalent of this object
    def to_note_off
      NoteOff.new(channel, note, velocity)
    end

  end

  #
  # MIDI Pitch Bend message
  #
  class PitchBend

    include ShortMessageBehavior
    include ChannelMessageBehavior

    schema :channel, :low, :high
    use_display_name 'Pitch Bend'

  end

  #
  # MIDI Polyphonic (note specific) Aftertouch message
  #
  class PolyphonicAftertouch

    include ShortMessageBehavior
    include ChannelMessageBehavior

    schema :channel, :note, :value
    use_display_name 'Polyphonic Aftertouch'
    use_constants 'Note', :for => :note

  end
  PolyAftertouch = PolyphonicAftertouch
  PolyPressure = PolyphonicAftertouch
  PolyphonicPressure = PolyphonicAftertouch

  #
  # MIDI Program Change message
  #
  class ProgramChange

    include ShortMessageBehavior
    include ChannelMessageBehavior

    schema :channel, :program
    use_display_name 'Program Change'

  end
  
end
