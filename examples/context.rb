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
  
  context.note_on("E4")
  context.note_off("E4")
  
  context.note_on("C4")
  context.note_off("C4")
  
  context.control_change("Portamento", 64)
    
  context.note_on("E4")
  context.note_off("E4")
  
  context.program_change(20)
  
end
