#!/usr/bin/env ruby

require 'test_helper'

class ShortMessageTest < Test::Unit::TestCase

  include MIDIMessage
  include TestHelper

  def test_channel_message
    msg = ChannelMessage.new(0x9, 0x0, 0x40, 0x40)
    assert_equal(0x9, msg.status[0])
    assert_equal(0x0, msg.status[1])
    assert_equal(0x40, msg.data[0])
    assert_equal(0x40, msg.data[1])
    assert_equal([0x90, 0x40, 0x40], msg.to_a)
    assert_equal("904040", msg.to_bytestr)    
  end
  
  def test_to_type
    msg = ChannelMessage.new(0x9, 0x0, 0x40, 0x40)
    typemsg = msg.to_type
    assert_equal(NoteOn, typemsg.class)
    assert_equal(msg.status[1], typemsg.channel)
    assert_equal(msg.data[0], typemsg.note)
    assert_equal(msg.data[1], typemsg.velocity)
    assert_equal(msg.to_a, typemsg.to_a)
    assert_equal(msg.to_bytestr, typemsg.to_bytestr)      
  end
   
  def test_note_off
    msg = NoteOff.new(0, 0x40, 0x40)
    assert_equal(0, msg.channel)
    assert_equal(0x40, msg.note)
    assert_equal(0x40, msg.velocity)
    assert_equal([0x80, 0x40, 0x40], msg.to_a)
    assert_equal("804040", msg.to_bytestr)
  end
  
  def test_note_on
    msg = NoteOn.new(0, 0x40, 0x40)
    assert_equal(0, msg.channel)
    assert_equal(0x40, msg.note)
    assert_equal(0x40, msg.velocity)
    assert_equal([0x90, 0x40, 0x40], msg.to_a)
    assert_equal("904040", msg.to_bytestr)  
  end  
  
  def test_polyphonic_aftertouch
    msg = PolyphonicAftertouch.new(1, 0x40, 0x40)
    assert_equal(1, msg.channel)
    assert_equal(0x40, msg.note)
    assert_equal(0x40, msg.value)
    assert_equal([0xA1, 0x40, 0x40], msg.to_a)
    assert_equal("A14040", msg.to_bytestr)      
  end  
  
  def test_control_change
    msg = ControlChange.new(2, 0x20, 0x20)
    assert_equal(msg.channel, 2)
    assert_equal(0x20, msg.number)
    assert_equal(0x20, msg.value)
    assert_equal([0xB2, 0x20, 0x20], msg.to_a)
    assert_equal("B22020", msg.to_bytestr)    
  end
  
  def test_program_change
    msg = ProgramChange.new(3, 0x40)
    assert_equal(3, msg.channel)
    assert_equal(0x40, msg.program)
    assert_equal([0xC3, 0x40], msg.to_a)
    assert_equal("C340", msg.to_bytestr)
  
  end
  
  def test_channel_aftertouch
    msg = ChannelAftertouch.new(3, 0x50)
    assert_equal(3, msg.channel)
    assert_equal(0x50, msg.value)
    assert_equal([0xD3, 0x50], msg.to_a)
    assert_equal("D350", msg.to_bytestr)  
  end  
    
  def test_channel_aftertouch
    msg = MIDIMessage::PitchBend.new(0, 0x50, 0xA0)
    assert_equal(0, msg.channel)
    assert_equal(0x50, msg.low)
    assert_equal(0xA0, msg.high)
    assert_equal([0xE0, 0x50, 0xA0], msg.to_a)
    assert_equal("E050A0", msg.to_bytestr)      
  end   
   
  def test_system_common
    msg = SystemCommon.new(1, 0x50, 0xA0)
    assert_equal(1, msg.status[1])
    assert_equal(0x50, msg.data[0])
    assert_equal(0xA0, msg.data[1])
    assert_equal([0xF1, 0x50, 0xA0], msg.to_a)
    assert_equal("F150A0", msg.to_bytestr)   
  end    
  
  def test_system_realtime
    msg = SystemRealtime.new(0x8)
    assert_equal(8, msg.id)
    assert_equal([0xF8], msg.to_a)
    assert_equal("F8", msg.to_bytestr)     
  end        
   
end