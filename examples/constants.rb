#!/usr/bin/env ruby

dir = File.dirname(File.expand_path(__FILE__))
$LOAD_PATH.unshift dir + '/../lib'

require 'midi-message'
require 'pp'

include MIDIMessage

# start and stop messages for a sequencer

pp SystemRealtime.new(Constant["System Realtime"]["Start"])
pp SystemRealtime.new(Constant["System Realtime"]["Stop"])


