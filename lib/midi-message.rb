#
# Ruby MIDI message objects
#
# (c)2011-2014 Ari Russo and licensed under the Apache 2.0 License
# 
module MIDIMessage
  
  module Event
  end
  
  module Process    
  end
  
  VERSION = "0.3.2"
 
end

# Libs
require "forwardable"
require "yaml"

# Messages (mixed format)
require "midi-message/short_message"
require "midi-message/channel_message"
require "midi-message/constant"
require "midi-message/context"
require "midi-message/note_message"
require "midi-message/parser"
require "midi-message/system_message"
require "midi-message/system_exclusive"
require "midi-message/type_conversion"

# Modules
require "midi-message/process/processor"

# Classes
require "midi-message/event/note"
require "midi-message/process/filter"
require "midi-message/process/limit"
require "midi-message/process/transpose"
