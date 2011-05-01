#!/usr/bin/env ruby
#
# MIDI Messages in Ruby
# (c)2011 Ari Russo and licensed under the Apache 2.0 License
# 
module MIDIMessage
  
  VERSION = "0.0.6"
 
end

require 'midi-message/simple_message'
require 'midi-message/channel_message'
require 'midi-message/constant'
require 'midi-message/parser'
require 'midi-message/system_message'
require 'midi-message/system_exclusive'
