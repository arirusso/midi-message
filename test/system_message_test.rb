require "helper"

class SystemMessageTest < Minitest::Test

  def test_system_common
    msg = MIDIMessage::SystemCommon.new(0x2, 0x00, 0x08)
    assert_equal("Song Position Pointer", msg.name)
    assert_equal(0xF, msg.status[0])
    assert_equal(0x2, msg.status[1])
    assert_equal(0x00, msg.data[0])
    assert_equal(0x08, msg.data[1])
    assert_equal([0xF2, 0x00, 0x08], msg.to_a)
    assert_equal("F20008", msg.to_bytestr)
  end

  def test_system_common_redundant
    msg = MIDIMessage::SystemCommon.new(0xF2, 0x00, 0x08)
    assert_equal("Song Position Pointer", msg.name)
    assert_equal(0xF, msg.status[0])
    assert_equal(0x2, msg.status[1])
    assert_equal(0x00, msg.data[0])
    assert_equal(0x08, msg.data[1])
    assert_equal([0xF2, 0x00, 0x08], msg.to_a)
    assert_equal("F20008", msg.to_bytestr)
  end

  def test_system_common_constant
    msg = MIDIMessage::SystemCommon["Song Position Pointer"].new(0x00, 0x08)
    assert_equal("Song Position Pointer", msg.name)
    assert_equal(0xF, msg.status[0])
    assert_equal(0x2, msg.status[1])
    assert_equal(0x00, msg.data[0])
    assert_equal(0x08, msg.data[1])
    assert_equal([0xF2, 0x00, 0x08], msg.to_a)
    assert_equal("F20008", msg.to_bytestr)
  end

  def test_system_realtime
    msg = MIDIMessage::SystemRealtime.new(0x8)
    assert_equal("Clock", msg.name)
    assert_equal(0xF, msg.status[0])
    assert_equal(0x8, msg.status[1])
    assert_equal([0xF8], msg.to_a)
    assert_equal("F8", msg.to_bytestr)
  end

  def test_system_realtime_redundant
    msg = MIDIMessage::SystemRealtime.new(0xF8)
    assert_equal("Clock", msg.name)
    assert_equal(0xF, msg.status[0])
    assert_equal(0x8, msg.status[1])
    assert_equal([0xF8], msg.to_a)
    assert_equal("F8", msg.to_bytestr)
  end

  def test_system_realtime_constant
    msg = MIDIMessage::SystemRealtime["Clock"].new
    assert_equal("Clock", msg.name)
    assert_equal(0xF, msg.status[0])
    assert_equal(0x8, msg.status[1])
    assert_equal([0xF8], msg.to_a)
    assert_equal("F8", msg.to_bytestr)
  end

end
