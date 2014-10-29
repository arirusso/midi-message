require "helper"

class SystemMessageTest < Test::Unit::TestCase

  include MIDIMessage

  def test_system_common
    msg = SystemCommon.new(0x2, 0x00, 0x08)
    assert_equal("Song Position Pointer", msg.name)
    assert_equal(0xF, msg.status[0])
    assert_equal(0x2, msg.status[1])
    assert_equal(0x00, msg.data[0])
    assert_equal(0x08, msg.data[1])
    assert_equal([0xF2, 0x00, 0x08], msg.to_a)
    assert_equal("F20008", msg.to_bytestr)
  end

  def test_system_common_redundant
    msg = SystemCommon.new(0xF2, 0x00, 0x08)
    assert_equal("Song Position Pointer", msg.name)
    assert_equal(0xF, msg.status[0])
    assert_equal(0x2, msg.status[1])
    assert_equal(0x00, msg.data[0])
    assert_equal(0x08, msg.data[1])
    assert_equal([0xF2, 0x00, 0x08], msg.to_a)
    assert_equal("F20008", msg.to_bytestr)
  end

  def test_system_common_constant
    msg = SystemCommon["Song Position Pointer"].new(0x00, 0x08)
    assert_equal("Song Position Pointer", msg.name)
    assert_equal(0xF, msg.status[0])
    assert_equal(0x2, msg.status[1])
    assert_equal(0x00, msg.data[0])
    assert_equal(0x08, msg.data[1])
    assert_equal([0xF2, 0x00, 0x08], msg.to_a)
    assert_equal("F20008", msg.to_bytestr)
  end

  def test_system_realtime
    msg = SystemRealtime.new(0x8)
    assert_equal("Clock", msg.name)
    assert_equal(0xF, msg.status[0])
    assert_equal(0x8, msg.status[1])
    assert_equal([0xF8], msg.to_a)
    assert_equal("F8", msg.to_bytestr)
  end

  def test_system_realtime_redundant
    msg = SystemRealtime.new(0xF8)
    assert_equal("Clock", msg.name)
    assert_equal(0xF, msg.status[0])
    assert_equal(0x8, msg.status[1])
    assert_equal([0xF8], msg.to_a)
    assert_equal("F8", msg.to_bytestr)
  end

  def test_system_realtime_constant
    msg = SystemRealtime["Clock"].new
    assert_equal("Clock", msg.name)
    assert_equal(0xF, msg.status[0])
    assert_equal(0x8, msg.status[1])
    assert_equal([0xF8], msg.to_a)
    assert_equal("F8", msg.to_bytestr)
  end

end
