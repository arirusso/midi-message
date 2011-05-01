#!/usr/bin/env ruby

require File.dirname(__FILE__) + '/test_helper'

class ShortMessageTest < Test::Unit::TestCase

  include MIDIMessage
  include TestHelper
 
  def test_note_off
    msg = NoteOff.new(0, 0x40, 0x40)
    assert_equal(0, msg.channel)
    assert_equal(0x40, msg.note)
    assert_equal(0x40, msg.velocity)  
  end
  
  def test_note_on
    msg = NoteOn.new(0, 0x40, 0x40)
    assert_equal(0, msg.channel)
    assert_equal(0x40, msg.note)
    assert_equal(0x40, msg.velocity)  
  end  
  
  def test_polyphonic_aftertouch
    msg = PolyphonicAftertouch.new(1, 0x40, 0x40)
    assert_equal(1, msg.channel)
    assert_equal(0x40, msg.note)
    assert_equal(0x40, msg.value)      
  end  
  
  def test_control_change
    msg = ControlChange.new(2, 0x20, 0x20)
    assert_equal(msg.channel, 2)
    assert_equal(0x20, msg.number)
    assert_equal(0x20, msg.value)    
  end
  
  def test_program_change
    msg = ProgramChange.new(3, 0x40)
    assert_equal(3, msg.channel)
    assert_equal(0x40, msg.program)  
  end
  
  def test_channel_aftertouch
    msg = ChannelAftertouch.new(3, 0x50)
    assert_equal(3, msg.channel)
    assert_equal(0x50, msg.value)  
  end  
    
  def test_channel_aftertouch
    msg = MIDIMessage::PitchBend.new(0, 0x50, 0xA0)
    assert_equal(0, msg.channel)
    assert_equal(0x50, msg.low)
    assert_equal(0xA0, msg.high)  
  end   
   
  def test_system_common
    msg = SystemCommon.new(1, 0x50, 0xA0)
    assert_equal(1, msg.status[1])
    assert_equal(0x50, msg.data[0])
    assert_equal(0xA0, msg.data[1])  
  end    
  
  def test_system_realtime
    msg = SystemRealtime.new(0x8)
    assert_equal(8, msg.id)
  end        
   
end