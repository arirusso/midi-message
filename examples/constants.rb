#!/usr/bin/env ruby

dir = File.dirname(File.expand_path(__FILE__))
$LOAD_PATH.unshift dir + '/../lib'

require 'midi-message'
require 'pp'

include MIDIMessage

# start and stop messages for a sequencer

# this api is still a little odd...

rt_msgs = Constant["System Realtime"]

pp SystemRealtime.new(rt_msgs["Start"])
pp SystemRealtime.new(rt_msgs["Stop"])

# this should output something like:

# #<MIDIMessage::SystemRealtime:0x89fda3c
#  @name="Start",
#  @status=[15, 250],
#  @verbose_name="System Realtime: Start">
# #<MIDIMessage::SystemRealtime:0x89fc600
#  @name="Stop",
#  @status=[15, 252],
#  @verbose_name="System Realtime: Stop">
