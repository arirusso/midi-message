#!/usr/bin/env ruby
# frozen_string_literal: true

#
# Construct a melody
#

$LOAD_PATH.unshift(File.join('..', 'lib'))

require 'midi-message'
require 'pp'

channel = 0
notes = [36, 40, 43] # C E G
octaves = 2
velocity = 100

melody = []

(0..((octaves - 1) * 12)).step(12) do |oct|
  notes.each do |note|
    melody << MIDIMessage::NoteOn.new(channel, note + oct, velocity)
  end
end

pp melody
