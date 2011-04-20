#!/usr/bin/env ruby
#
# This example takes all midi input, transposes the notes up one octave and then outputs everything
#
require 'midi-messenger'
include MIDIMessenger

# this example selects the first available input and output devices.  for other
# configurations, see the example "selecting_a_device.rb" to see how devices are 
# selected
input = Device.first(:input)
#output = Device.first(:output)

while true do
  msgs = input.read
  #msgs.each do |msg|
  #  $>.puts "received note #{msg.note}, outputting note #{(msg.note += 12)}" if msg.is_a?(Message::NoteOn)
 #   output.send_message(msg)
 # end
 p msgs
 sleep 0.2
end