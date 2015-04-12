#!/usr/bin/env ruby
#
# Construct a melody
#

$:.unshift(File.join("..", "lib"))

require "midi-message"
require "pp"

channel = 0
notes = [36, 40, 43] # C E G
octaves = 2
velocity = 100

melody = []

(0..((octaves-1)*12)).step(12) do |oct|

  notes.each { |note| melody << MIDIMessage::NoteOn.new(channel, note + oct, velocity) }

end

pp melody

# this should output something like:

# (will add when I have the constants yaml more filled out)
