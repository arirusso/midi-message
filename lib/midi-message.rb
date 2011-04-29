#!/usr/bin/env ruby
#
# MIDI Messages in Ruby
#
module MIDIMessage
  
  VERSION = "0.0.1"
 
end

require 'midi-message/simple_message'
require 'midi-message/channel_message'
require 'midi-message/constant'
require 'midi-message/system_message'
require 'midi-message/system_exclusive'
