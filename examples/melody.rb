#!/usr/bin/env ruby
#
# Construct a melody
#

dir = File.dirname(File.expand_path(__FILE__))
$LOAD_PATH.unshift dir + '/../lib'

require 'midi-message'
require 'pp'

notes = [36, 40, 43] # C E G
octaves = 5
melody = []

(0..((octaves-1)*12)).step(12) do |oct|

  notes.each { |note| melody << MIDIMessage::NoteOn.new(note + oct, 100) }
    
end

pp melody
