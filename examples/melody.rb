#!/usr/bin/env ruby
#
# Construct a melody
#

dir = File.dirname(File.expand_path(__FILE__))
$LOAD_PATH.unshift dir + '/../lib'

require 'midi-message'
require 'pp'

channel = 0
notes = [36, 40, 43] # C E G
octaves = 5
velocity = 100

melody = []

(0..((octaves-1)*12)).step(12) do |oct|

  notes.each { |note| melody << MIDIMessage::NoteOn.new(channel, note + oct, velocity) }
    
end

pp melody
