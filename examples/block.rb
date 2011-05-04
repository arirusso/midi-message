#!/usr/bin/env ruby
#
# Use a block loaded with velocity and channel
#

dir = File.dirname(File.expand_path(__FILE__))
$LOAD_PATH.unshift dir + '/../lib'

require 'midi-message'
require 'pp'

include MIDIMessage

with(:channel => 0, :velocity => 100) do |context|
  
  pp context.note_on("E4")
  pp context.note_off("E4")
  
  pp context.note_on("C4")
  pp context.note_off("C4")
  
  pp context.control_change("Portamento", 64)
    
  pp context.note_on("E4")
  pp context.note_off("E4")  
  
end
