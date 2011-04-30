#!/usr/bin/env ruby
#
# Instantiate SysEx messages
#

dir = File.dirname(File.expand_path(__FILE__))
$LOAD_PATH.unshift dir + '/../lib'

require 'midi-message'
require 'pp'

pp MIDIMessage.parse(0xF0, 0x41, 0x10, 0x42, 0x12, 0x40, 0x00, 0x7F, 0x00, 0x41, 0xF7)

pp MIDIMessage.parse(0x90, 0x40, 0x40)

# this should output something like:

# #<MIDIMessage::SystemExclusive::Command:0x9c1e57c
# @address=[64, 0, 127],
# @checksum=[65],
# @data=[0],
# @node=
#  #<MIDIMessage::SystemExclusive::Node:0x9c1e5a4
#   @device_id=16,
#   @manufacturer=65,
#   @model_id=66>>
#
# #<MIDIMessage::NoteOn:0x9c1c240
# @channel=0,
# @data=[64, 64],
# @name="E4",
# @note=64,
# @status=[9, 0],
# @velocity=64,
# @verbose_name="Note On: E4">
#
