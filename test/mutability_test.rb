require "helper"

class MutabilityTest < Test::Unit::TestCase

  def test_note
    msg = MIDIMessage::NoteOn["E4"].new(0, 100)
    assert_equal(0x40, msg.note)
    assert_equal("E4", msg.name)
    msg.note += 5
    assert_equal(0x45, msg.note)
    assert_equal("A4", msg.name)
  end

  def test_octave
    msg = MIDIMessage::NoteOn["E4"].new(0, 100)
    assert_equal(0x40, msg.note)
    assert_equal("E4", msg.name)
    msg.octave += 1
    assert_equal(0x4C, msg.note)
    assert_equal("E5", msg.name)
  end

end
