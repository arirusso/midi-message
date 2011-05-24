#!/usr/bin/env ruby

require 'helper'

class ConstantsTest < Test::Unit::TestCase

  include MIDIMessage
  include TestHelper        
   
  def test_note_on
    msg = NoteOn["C3"].new(0, 100)
    assert_equal(NoteOn, msg.class)
    assert_equal("C3", msg.name)
    assert_equal([0x90, 0x30, 100], msg.to_a)  
  end 
  
end