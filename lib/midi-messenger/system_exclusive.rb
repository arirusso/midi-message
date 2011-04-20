#!/usr/bin/env ruby
#
# Modules and classes for dealing with System Exclusive messages
#
module MIDIMessenger
    
    module SystemExclusive
  
  # convert raw MIDI data to SysEx message objects
  def self.create_from_byte_str(hex_digits)
    p hex_digits
    sysex_start = hex_digits.slice!(0,2)
    str = ''
    str += hex_digits.slice!(0,2) until hex_digits[0,2].eql?('f7')
    fixed_length_message_part = str.slice!(0,14)
    
    manufacturer_id = fixed_length_message_part[0,2]
    device_id = fixed_length_message_part[2,2]
    model_id = fixed_length_message_part[4,2]
    msg_class = case fixed_length_message_part[6,2]
      when '11' then Request
      when '12' then Message
    end
    address = fixed_length_message_part[8,6]
    checksum = str.slice!((str.length - 2), 2)
    value = str
    
    node = MIDIMessenger::SysEx::Node.new(manufacturer_id, model_id, :device_id => device_id)
    object = msg_class.new(address, value, :checksum => checksum, :node => node)
    { :object => object, :remaining_hex_digits => hex_digits }
  end
  
  # basic SysEx data that a message class will contain
  module Data
    
    attr_reader :device, :address, :checksum
    
    def start_byte 
      0xF0
    end
    
    def end_byte
      0xF7
    end
    
    # an array of message parts.  multiple byte parts will be represented as an array of bytes 
    def to_a
      @array
    end
    
    # a flat array of message bytes 
    def to_byte_array
      @array.flatten
    end
    
    def address=(val)
      @address = val
      update_array
    end
    
    private
    
    def address_as_dec
      address.inject { |a,b| a+b }
    end
    
    def value_as_dec
      value.kind_of?(Array) ? value.inject { |a,b| a+b } : value
    end
    
    def initialize_sysex(address, options = {})
      @node = options[:node]
      @checksum = options[:checksum]
      @array = []
      @address = address
      update_array
    end
    
    # cache this message as an array for output
    def update_array
      @checksum = (128 - (address_as_dec + value_as_dec).divmod(128)[1])
      @array[0] = start_byte
      @array[1] = @node.manufacturer 
      @array[2] = @device_id || @node.device_id
      @array[3] = @node.model_id
      @array[4] = status_byte
      @array[5] = address
      @array[6] = value
      @array[7] = @checksum
      @array[8] = end_byte
    end
    
  end
  
  # A SysEx command message
  #
  class Command
    
    include Data
    
    attr_reader :data
    
    def initialize(address, data, options = {})
      @data = data
      initialize_sysex(address, options)
    end
    
    def status_byte
      0x12
    end
    
    def value
      @data
    end
    
    def data=(val)
      @data = val
      update_byte_array
    end
    
  end

  #
  # The SystemExclusive::Node represents a hardware synthesizer or other MIDI device that a message 
  # is being sent to or received from.
  #
  class Node
    
    attr_accessor :device_id # (Not to be confused with any kind of Device class in this library) 
    attr_reader :manufacturer, :model_id
    
    def initialize(manufacturer, model_id, options = {})
      @device_id = options[:device_id]
      @model_id = model_id
      @manufacturer = manufacturer
    end
    
    def message(*a)
      a << { :node => self }
      Command.new(*a)
    end
    
  end
  
  # A SysEx request message 
  #
  class Request
    
    include Data
    
    attr_reader :size
    
    def initialize(address, size, options = {})
      @size = size
      initialize_sysex(address, options = {})
    end
    
    def status_byte
      0x11
    end
    
    def value
      @size
    end
    
    def size=(val)
      @size = val
      update_byte_array
    end
    
  end
  
  end
end