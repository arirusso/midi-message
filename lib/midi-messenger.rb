#!/usr/bin/env ruby
#
# A High-level realtime MIDI interface for Ruby
#
module MIDIMessenger
  
  VERSION = "0.0.1"
 
end

require 'unimidi'

require 'message/channel_message'
require 'message/node'
require 'message/parser'
require 'message/system_message'
require 'message/system_exclusive'
