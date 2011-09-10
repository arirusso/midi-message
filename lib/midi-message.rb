#!/usr/bin/env ruby
#
# MIDI Messages in Ruby
# (c)2011 Ari Russo and licensed under the Apache 2.0 License
# 
module MIDIMessage
  
  module Process    
  end
  
  VERSION = "0.2.1"
 
end

require 'yaml'

# messages

require 'midi-message/short_message'
require 'midi-message/channel_message'
require 'midi-message/constant'
require 'midi-message/context'
require 'midi-message/note_message'
require 'midi-message/parser'
require 'midi-message/system_message'
require 'midi-message/system_exclusive'
require 'midi-message/type_conversion'

# message processors

# modules
require "midi-message/process/processor"

# classes
require "midi-message/process/filter"
require "midi-message/process/limit"
require "midi-message/process/transpose"