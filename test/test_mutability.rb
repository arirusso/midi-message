#!/usr/bin/env ruby

require 'helper'

class MutabilityTest < Test::Unit::TestCase

  include MIDIMessage
  include TestHelper
  
  def test_note
    msg = NoteOn["E4"].new(0, 100)
    assert_equal(0x40, msg.note)
    assert_equal("E4", msg.name)
    msg.note += 5
    assert_equal(0x45, msg.note)
    assert_equal("A4", msg.name)     
  end

  def test_octave
    msg = NoteOn["E4"].new(0, 100)
    assert_equal(0x40, msg.note)
    assert_equal("E4", msg.name)
    msg.octave += 1
    assert_equal(0x4C, msg.note)
    assert_equal("E5", msg.name)     
  end
   
end