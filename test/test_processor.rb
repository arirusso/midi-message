#!/usr/bin/env ruby

require 'helper'

class ProcessorTest < Test::Unit::TestCase

  include MIDIMessage
  include MIDIMessage::Process
  include TestHelper

  def test_class_method
    msg = MIDIMessage::NoteOn["C4"].new(0, 100)
    assert_equal(60, msg.note)
    Transpose.process(msg, :note, 5)
    assert_equal(65, msg.note)
  end


end