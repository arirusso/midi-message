# frozen_string_literal: true

#
# Ruby MIDI message objects
#
# (c)2011-2015 Ari Russo
# Apache 2.0 License
#

# Libs
require 'forwardable'
require 'yaml'

# Modules
require 'midi-message/constant'
require 'midi-message/message'
require 'midi-message/channel_message'
require 'midi-message/note_message'
require 'midi-message/system_exclusive'
require 'midi-message/system_message'
require 'midi-message/type_conversion'

# Classes
require 'midi-message/context'
require 'midi-message/messages'
require 'midi-message/parser'

module MIDIMessage
  VERSION = '0.4.9'
end
