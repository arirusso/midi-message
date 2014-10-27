#!/usr/bin/env ruby
#
# Walk through of different ways to instantiate short (non-sysex) MIDI Messages
#

dir = File.dirname(File.expand_path(__FILE__))
$LOAD_PATH.unshift dir + "/../lib"

require "midi-message"
require "pp"

# Here are examples of different ways to construct messages, going from low to high-level

pp MIDIMessage.parse(0x90, 0x40, 0x40)

channel_msg = MIDIMessageChannelMessage.new(0x9, 0x0, 0x40, 0x40)

pp channel_msg

# this will return a NoteOn object with the properties of channel_msg
pp channel_msg.to_type

pp MIDIMessage::ChannelMessage.new(MIDIMessage::Status["Note On"], 0x0, 0x40, 0x40)

pp MIDIMessage::ChannelMessage.new(MIDIMessage::Status["Note On"], 0x0, 0x40, 0x40).to_type

pp MIDIMessage::NoteOn.new(0, 64, 64) # or NoteOn.new(0x0, 0x64, 0x64)

# some message properties are mutable

pp msg = MIDIMessage::NoteOn["E4"].new(0, 100)

msg.note += 5

pp msg
