#!/usr/bin/env ruby
#
# MIDI Messages in Ruby
#
module MIDIMessage
  
  VERSION = "0.0.3"
 
end

require 'midi-message/simple_message'
require 'midi-message/channel_message'
require 'midi-message/constant'
require 'midi-message/parser'
require 'midi-message/system_message'
require 'midi-message/system_exclusive'
