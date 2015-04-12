#!/usr/bin/env ruby
#
# How to use constants
#

$:.unshift(File.join("..", "lib"))

require "midi-message"
require "pp"

# some messages for a sequencer

pp MIDIMessage::SystemRealtime["Start"].new
pp MIDIMessage::NoteOn["E4"].new(0, 100)
pp MIDIMessage::SystemRealtime["Stop"].new

# this should output something like:

#
# #<MIDIMessage::SystemRealtime:0x89fda3c
#  @name="Start",
#  @status=[15, 250],
#  @verbose_name="System Realtime: Start">
#
# #<MIDIMessage::NoteOn:0x9363cac
#  @channel=0,
#  @data=[64, 100],
#  @name="C3",
#  @note=64,
#  @status=[9, 0],
#  @velocity=100,
#  @verbose_name="Note On: C3">
#
# #<MIDIMessage::SystemRealtime:0x89fc600
#  @name="Stop",
#  @status=[15, 252],
#  @verbose_name="System Realtime: Stop">
#
