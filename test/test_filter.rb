#!/usr/bin/env ruby

require 'helper'

class FilterTest < Test::Unit::TestCase

  include MIDIMessage
  include MIDIMessage::Process
  include TestHelper

  def test_high_pass_note_reject
    msg = MIDIMessage::NoteOn["C0"].new(0, 100)
    assert_equal(12, msg.note)
    outp = HighPassFilter.new(:note, 20).process(msg)
    assert_equal(nil, outp)
  end

  def test_high_pass_note_accept
    msg = MIDIMessage::NoteOn["C4"].new(0, 100)
    assert_equal(60, msg.note)
    outp = HighPassFilter.new(:note, 20).process(msg)
    assert_equal(msg, outp)
  end

  def test_low_pass_note_reject
    msg = MIDIMessage::NoteOn["C4"].new(0, 100)
    assert_equal(60, msg.note)
    outp = LowPassFilter.new(:note, 50).process(msg)
    assert_equal(nil, outp)
  end

  def test_low_pass_note_accept
    msg = MIDIMessage::NoteOn["C4"].new(0, 100)
    assert_equal(60, msg.note)
    outp = LowPassFilter.new(:note, 100).process(msg)
    assert_equal(msg, outp)
  end

  def test_band_pass_note_reject
    msg = MIDIMessage::NoteOn["C4"].new(0, 100)
    assert_equal(60, msg.note)
    outp = BandPassFilter.new(:note, (20..50)).process(msg)
    assert_equal(nil, outp)
  end

  def test_band_pass_note_accept
    msg = MIDIMessage::NoteOn["C4"].new(0, 100)
    assert_equal(60, msg.note)
    outp = BandPassFilter.new(:note, (20..100)).process(msg)
    assert_equal(msg, outp)
  end
  
  def test_band_reject_note_reject
    msg = MIDIMessage::NoteOn["C4"].new(0, 100)
    assert_equal(60, msg.note)
    outp = NotchFilter.new(:note, (20..70)).process(msg)
    assert_equal(nil, outp)
  end

  def test_band_reject_note_accept
    msg = MIDIMessage::NoteOn["C4"].new(0, 100)
    assert_equal(60, msg.note)
    outp = NotchFilter.new(:note, (20..50)).process(msg)
    assert_equal(msg, outp)
  end
  
  def test_multiband_note_reject
    msg = MIDIMessage::NoteOn["C4"].new(0, 100)
    assert_equal(60, msg.note)
    outp = Filter.new(:note, [(20..30), (40..50)]).process(msg)
    assert_equal(nil, outp)
  end

  def test_multiband_note_accept
    msg = MIDIMessage::NoteOn["C4"].new(0, 100)
    assert_equal(60, msg.note)
    outp = Filter.new(:note, [(20..30), (50..70)]).process(msg)
    assert_equal(msg, outp)
  end
  
  def test_multinotch_note_reject
    msg = MIDIMessage::NoteOn["C4"].new(0, 100)
    assert_equal(60, msg.note)
    outp = Filter.new(:note, [(20..30), (55..65)], :reject => true).process(msg)
    assert_equal(nil, outp)
  end

  def test_multinotch_note_accept
    msg = MIDIMessage::NoteOn["C4"].new(0, 100)
    assert_equal(60, msg.note)
    outp = Filter.new(:note, [(20..30), (40..50)], :reject => true).process(msg)
    assert_equal(msg, outp)
  end
  
end