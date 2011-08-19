#!/usr/bin/env ruby

require 'helper'

class ConstantsTest < Test::Unit::TestCase

  include MIDIMessage
  include TestHelper        
   
  def test_note_on
    msg = NoteOn["c3"].new(0, 100)
    assert_equal(NoteOn, msg.class)
    assert_equal("C3", msg.name)
    assert_equal("C", msg.note_name)
    assert_equal([0x90, 0x30, 100], msg.to_a)  
  end 
  
  def test_control_change
    msg = NoteOn["C3"].new(0, 100)
    assert_equal(NoteOn, msg.class)
    assert_equal("C3", msg.name)
    assert_equal([0x90, 0x30, 100], msg.to_a)      
  end
  
  def test_control_change
    msg = ControlChange["Modulation Wheel"].new(2, 0x20)
    assert_equal(ControlChange, msg.class)
    assert_equal(msg.channel, 2)
    assert_equal(0x01, msg.index)
    assert_equal(0x20, msg.value)
    assert_equal([0xB2, 0x01, 0x20], msg.to_a)    
  end

  def test_system_realtime
    msg = SystemRealtime["Stop"].new
    assert_equal(SystemRealtime, msg.class)
    assert_equal("Stop", msg.name)
    assert_equal([0xFC], msg.to_a)     
  end  
  
  def test_system_common
    msg = SystemCommon["Song Select"].new
    assert_equal(SystemCommon, msg.class)
    assert_equal("Song Select", msg.name)
    assert_equal([0xF3], msg.to_a)      
  end  
  
end