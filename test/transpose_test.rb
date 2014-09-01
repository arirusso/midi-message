#!/usr/bin/env ruby

require 'helper'

class TransposeTest < Test::Unit::TestCase

  include MIDIMessage
  include MIDIMessage::Process
  include TestHelper

  def test_transpose_note_up
    msg = MIDIMessage::NoteOn["C4"].new(0, 100)
    assert_equal(60, msg.note)
    Transpose.new(:note, 5).process(msg)
    assert_equal(65, msg.note)
  end

  def test_transpose_velocity_up
    msg = MIDIMessage::NoteOn["C4"].new(0, 82)
    assert_equal(82, msg.velocity)
    Transpose.new(:velocity, 10).process(msg)
    assert_equal(92, msg.velocity)
  end

  def test_transpose_note_down
    msg = MIDIMessage::NoteOn["C4"].new(0, 100)
    assert_equal(60, msg.note)
    Transpose.new(:note, -5).process(msg)
    assert_equal(55, msg.note)
  end

  def test_transpose_velocity_down
    msg = MIDIMessage::NoteOn["C4"].new(0, 82)
    assert_equal(82, msg.velocity)
    Transpose.new(:velocity, -10).process(msg)
    assert_equal(72, msg.velocity)
  end

end