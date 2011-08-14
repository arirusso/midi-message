#!/usr/bin/env ruby

require 'helper'

class ParserTest < Test::Unit::TestCase

  include MIDIMessage
  include TestHelper
  
  def test_sysex
    msg = MIDIMessage.parse(0xF0, 0x41, 0x10, 0x42, 0x12, 0x40, 0x00, 0x7F, 0x00, 0x41, 0xF7)
    assert_equal(SystemExclusive::Command, msg.class)
    assert_equal(SystemExclusive::Node, msg.node.class) 
    assert_equal([0x40, 0x00, 0x7F], msg.address)
    assert_equal([0xF0, 0x41, 0x10, 0x42, 0x12, 0x40, 0x00, 0x7F, 0x00, 0x41, 0xF7], msg.to_bytes)      
  end        
  
  def test_note_off
    msg = MIDIMessage.parse(0x80, 0x40, 0x40)
    assert_equal(NoteOff, msg.class)
    assert_equal([0x80, 0x40, 0x40], msg.to_a)
  end
  
  def test_note_on
    msg = MIDIMessage.parse(0x90, 0x40, 0x40)
    assert_equal(NoteOn, msg.class)
    assert_equal([0x90, 0x40, 0x40], msg.to_a)  
  end  
  
  def test_polyphonic_aftertouch
    msg = MIDIMessage.parse(0xA1, 0x40, 0x40)
    assert_equal(PolyphonicAftertouch, msg.class)
    assert_equal([0xA1, 0x40, 0x40], msg.to_a)      
  end  
  
  def test_control_change
    msg = MIDIMessage.parse(0xB2, 0x20, 0x20)
    assert_equal(ControlChange, msg.class)
    assert_equal([0xB2, 0x20, 0x20], msg.to_a)    
  end
  
  def test_program_change
    msg = MIDIMessage.parse(0xC3, 0x40)
    assert_equal(ProgramChange, msg.class)
    assert_equal("C340", msg.to_bytestr)
  end
  
  def test_channel_aftertouch
    msg = MIDIMessage.parse("D350")
    assert_equal(ChannelAftertouch, msg.class)
    assert_equal([0xD3, 0x50], msg.to_a)  
  end  
    
  def test_pitch_bend
    msg = MIDIMessage.parse("E050A0")
    assert_equal(PitchBend, msg.class)
    assert_equal([0xE0, 0x50, 0xA0], msg.to_a)      
  end   
   
  def test_system_common
    msg = MIDIMessage.parse([0xF1, 0x50, 0xA0])
    assert_equal(SystemCommon, msg.class)
    assert_equal([0xF1, 0x50, 0xA0], msg.to_a)   
  end    
  
  def test_system_realtime
    msg = MIDIMessage.parse(0xF8)
    assert_equal(SystemRealtime, msg.class)
    assert_equal([0xF8], msg.to_a)     
  end        
   
end