#!/usr/bin/env ruby
#
module MIDIMessage

  # common behavior amongst Channel Message types
  module ChannelMessageBehavior

    attr_reader :data,
                :name
                  
    def initialize_channel_message(status_nibble_1, status_nibble_2, data_byte_1, data_byte_2 = 0)
      @status = [status_nibble_1, status_nibble_2]
      @data = [data_byte_1]
      @data[1] = data_byte_2 if self.class::second_data_byte?
      initialize_shortcuts
      initialize_short_message(status_nibble_1, status_nibble_2)
    end

    def initialize(*a)
      options = a.pop if a.last.kind_of?(Hash)
      unless options.nil? || options[:const].nil?
        key = self.class::ConstProp rescue nil
        ind = self.class::Shortcuts.index(key) rescue nil
      ind ||= 0
      a.insert(ind, options[:const])
      end
      initialize_channel_message(self.class.type_for_status, *a)
    end

    def self.included(base)
      base.extend(ClassMethods)
    end

    module ClassMethods
      
      def type_for_status
        display_name = get_display_name
        Status[display_name] unless display_name.nil?
      end

      def schema(*args)
        self.send(:const_set, :Shortcuts, args)
        const_set(:NumDataBytes, args.length-1)
      end
      alias_method :layout, :schema

      def second_data_byte?
        num = const_get(:NumDataBytes) rescue nil
        num.nil? || num > 1
      end

    end

    def initialize_shortcuts
      props = [
        { :name => :status, :index => 1 },
        { :name => :data, :index => 0 },
        { :name => :data, :index => 1 }
      ]
      shortcuts = self.class.send(:const_get, :Shortcuts) rescue []
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

    include ShortMessageBehavior
    include ChannelMessageBehavior

    display_name 'Channel Message'
    
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
    display_name 'Channel Aftertouch'

  end
  ChannelPressure = ChannelAftertouch

  #
  # MIDI Control Change message
  #
  class ControlChange

    include ShortMessageBehavior
    include ChannelMessageBehavior

    schema :channel, :index, :value
    display_name 'Control Change'
    use_constants 'Control Change', :for => 'Index'
   
  end  
  Controller = ControlChange #shortcut

  #
  # MIDI Note-Off message
  #
  class NoteOff

    include ShortMessageBehavior
    include ChannelMessageBehavior

    schema :channel, :note, :velocity
    display_name 'Note Off'
    use_constants 'Note', :for => :note

  end

  #
  # MIDI Note-On message
  #
  class NoteOn

    include ShortMessageBehavior
    include ChannelMessageBehavior

    schema :channel, :note, :velocity
    display_name 'Note On'
    use_constants 'Note', :for => :note

  end

  #
  # MIDI Pitch Bend message
  #
  class PitchBend

    include ShortMessageBehavior
    include ChannelMessageBehavior

    schema :channel, :low, :high
    display_name 'Pitch Bend'

  end

  #
  # MIDI Polyphonic (note specific) Aftertouch message
  #
  class PolyphonicAftertouch

    include ShortMessageBehavior
    include ChannelMessageBehavior

    schema :channel, :note, :value
    display_name 'Polyphonic Aftertouch'
    use_constants 'Note', :for => :note

  end
  PolyAftertouch = PolyphonicAftertouch
  PolyPressure = PolyphonicAftertouch

  #
  # MIDI Program Change message
  #
  class ProgramChange

    include ShortMessageBehavior
    include ChannelMessageBehavior

    schema :channel, :program
    display_name 'Program Change'

  end
  
  def with_context(options = {}, &block)
    block.call(Context.new(options))
  end
  alias_method :with, :with_context

end
