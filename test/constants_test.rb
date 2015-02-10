require "helper"

class ConstantsTest < Minitest::Test

  def test_note_on
    msg = MIDIMessage::NoteOn["c3"].new(0, 100)
    assert_equal(MIDIMessage::NoteOn, msg.class)
    assert_equal("C3", msg.name)
    assert_equal("C", msg.note_name)
    assert_equal("Note On: C3", msg.verbose_name)
    assert_equal([0x90, 0x30, 100], msg.to_a)
  end

  def test_control_change
    msg = MIDIMessage::NoteOn["C3"].new(0, 100)
    assert_equal(MIDIMessage::NoteOn, msg.class)
    assert_equal("C3", msg.name)
    assert_equal([0x90, 0x30, 100], msg.to_a)
  end

  def test_control_change
    msg = MIDIMessage::ControlChange["Modulation Wheel"].new(2, 0x20)
    assert_equal(MIDIMessage::ControlChange, msg.class)
    assert_equal(msg.channel, 2)
    assert_equal(0x01, msg.index)
    assert_equal(0x20, msg.value)
    assert_equal([0xB2, 0x01, 0x20], msg.to_a)
  end

  def test_system_realtime
    msg = MIDIMessage::SystemRealtime["Stop"].new
    assert_equal(MIDIMessage::SystemRealtime, msg.class)
    assert_equal("Stop", msg.name)
    assert_equal([0xFC], msg.to_a)
  end

  def test_system_common
    msg = MIDIMessage::SystemCommon["Song Select"].new
    assert_equal(MIDIMessage::SystemCommon, msg.class)
    assert_equal("Song Select", msg.name)
    assert_equal([0xF3], msg.to_a)
  end

end
