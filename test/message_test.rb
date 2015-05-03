require "helper"

class MIDIMessage::MessageTest < Minitest::Test

  context "Message" do

    context "#update" do

      context "note" do

        setup do
          @message = MIDIMessage::NoteOn["E4"].new(0, 100)
          assert_equal(0x40, @message.note)
          assert_equal("E4", @message.name)
        end

        should "be mutable" do
          @message.note += 5
          assert_equal(0x45, @message.note)
          assert_equal("A4", @message.name)
        end

      end

      context "octave" do

        setup do
          @message = MIDIMessage::NoteOn["E4"].new(0, 100)
          assert_equal(0x40, @message.note)
          assert_equal("E4", @message.name)
        end

        should "be mutable" do
          @message.octave += 1
          assert_equal(0x4C, @message.note)
          assert_equal("E5", @message.name)
        end

      end

    end

  end

end
