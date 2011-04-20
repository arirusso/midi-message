#!/usr/bin/env ruby
#
# This example sets the master volume output to 100 on a Roland SC-55 Sound Canvas module
#

require 'midi-messenger'
include MIDIMessenger
 
o = Device.first(:output)
i = Device.first(:input)

sleep 1

sc55 = MIDIMessenger::Message::SystemExclusive::Node.new(
  0x41, 
  0x42, # this is the sc-55's SysEx model id 
  :device_id => 0x10)
  
volume_address = [0x40,0x00,0x04]
volume_amount = 78

m = sc55.message(volume_address, volume_amount)



o.send_message(m)
puts (i.read)






