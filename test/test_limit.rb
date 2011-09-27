#!/usr/bin/env ruby

require 'helper'

class LimitTest < Test::Unit::TestCase

  include MIDIMessage
  include MIDIMessage::Process
  include TestHelper
  
  def test_numeric_range
    msg = MIDIMessage::NoteOn["C0"].new(0, 100)
    assert_equal(12, msg.note)
    Limit.new(:note, 30).process(msg)
    assert_equal(30, msg.note)    
  end

  def test_low_note
    msg = MIDIMessage::NoteOn["C0"].new(0, 100)
    assert_equal(12, msg.note)
    Limit.new(:note, (20..50)).process(msg)
    assert_equal(20, msg.note)
  end

  def test_high_note
    msg = MIDIMessage::NoteOn["C6"].new(0, 100)
    assert_equal(84, msg.note)
    Limit.new(:note, (20..50)).process(msg)
    assert_equal(50, msg.note)
  end

  def test_low_velocity
    msg = MIDIMessage::NoteOn["C0"].new(0, 10)
    assert_equal(10, msg.velocity)
    Limit.new(:velocity, (30..110)).process(msg)
    assert_equal(30, msg.velocity)
  end

  def test_high_velocity
    msg = MIDIMessage::NoteOn["C6"].new(0, 120)
    assert_equal(120, msg.velocity)
    Limit.new(:velocity, (25..75)).process(msg)
    assert_equal(75, msg.velocity)
  end
  
end