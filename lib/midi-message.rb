#!/usr/bin/env ruby
#
# MIDI Messages in Ruby
# (c)2011 Ari Russo and licensed under the Apache 2.0 License
# 
#
module MIDIMessage
  
  VERSION = "0.1.4"
 
end

require 'yaml'

require 'midi-message/short_message'
require 'midi-message/channel_message'
require 'midi-message/constant'
require 'midi-message/context'
require 'midi-message/parser'
require 'midi-message/system_message'
require 'midi-message/system_exclusive'
require 'midi-message/type_conversion'