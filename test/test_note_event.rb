#!/usr/bin/env ruby

require 'helper'

class NoteEventTest < Test::Unit::TestCase

  include MIDIMessage
  include TestHelper
  
  def test_create_event
    msg = NoteOn.new(0, 0x40, 0x40)
    event = Event::Note.new(msg, 10)
    assert_equal(msg, event.start)
    assert_equal(10, event.duration)
    assert_equal(NoteOff, event.finish.class)
    assert_equal(msg.note, event.finish.note)
    assert_equal(msg.note, event.note) 
  end

  def test_override_finish
    msg = NoteOn.new(0, 0x40, 0x40)
    msg2 = NoteOff.new(0, 0x40, 127)
    event = Event::Note.new(msg, 5, :finish => msg2)
    assert_equal(msg, event.start)
    assert_equal(5, event.duration)
    assert_equal(0x40, event.start.velocity)
    assert_equal(NoteOff, event.finish.class)
    assert_equal(0x40, event.finish.note)
    assert_equal(127, event.finish.velocity)
  end
  
end