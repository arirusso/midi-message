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


