#!/usr/bin/env ruby
#
# Walk through of different ways to instantiate System Exclusive (SysEx) messages
#

$:.unshift(File.join("..", "lib"))

require "midi-message"
require "pp"

# you can create a message by parsing bytes

pp MIDIMessage.parse(0xF0, 0x41, 0x10, 0x42, 0x12, 0x40, 0x00, 0x7F, 0x00, 0x41, 0xF7)

# or create a Node (destination) object and then send messages to that.
# a Node represents a device that you"re sending a message to
# (eg. your Yamaha DX7 is a Node).

node = MIDIMessage::SystemExclusive::Node.new(0x41, :model_id => 0x42, :device_id => 0x10)

# The following will create a command object for address "407F00" with value "00"
# associated with our node
#
# A command is a sysex message where the status (byte index 4) is 0x12
#
# A Request type message (SystemExclusive::Request) has a status byte
# equal to 0x11

pp MIDIMessage::SystemExclusive::Command.new([0x40, 0x7F, 0x00], 0x00, :node => node)

# it is actually optional to pass a node to your message-- one case where not
# doing so is useful is when want to have a generic message prototype used with
# multiple nodes

prototype = MIDIMessage::SystemExclusive::Command.new([0x40, 0x7F, 0x00], 0x00)

pp node.new_message_from(prototype) # this will create a new message using the prototype"s data and the node"s information

# you can also generate a totally new message from the Node

pp node.command([0x40, 0x7F, 0x00], 0x00)

# each of the print statements in this example should output a message something like:

#
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

# read more about SysEx messages in general here: http://www.2writers.com/eddie/TutSysEx.htm
