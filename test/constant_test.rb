require "helper"

class ConstantTest < Minitest::Test

  context "Constant" do

    context ".find" do

      setup do
        @map = MIDIMessage::Constant.find(:note, "C2")
      end

      should "return constant mapping" do
        refute_nil @map
        assert_equal MIDIMessage::Constant::Map, @map.class
        assert_equal 36, @map.value
      end

    end

    context ".value" do

      setup do
        @value = MIDIMessage::Constant.value(:note, "C3")
      end

      should "return constant value" do
        refute_nil @value
        assert_equal 48, @value
        assert_equal MIDIMessage::NoteOn.new(0, @value, 100).note, @value
        assert_equal MIDIMessage::NoteOn["C3"].new(0, 100).note, @value
      end

    end

    context "Loader" do

      context "DSL" do

        context "#[]" do

          context "note on" do

            setup do
              @message = MIDIMessage::NoteOn["c3"].new(0, 100)
            end

            should "create message object" do
              assert_equal(MIDIMessage::NoteOn, @message.class)
              assert_equal("C3", @message.name)
              assert_equal("C", @message.note_name)
              assert_equal("Note On: C3", @message.verbose_name)
              assert_equal([0x90, 0x30, 100], @message.to_a)
            end

          end

          context "note off" do

            setup do
              @message = MIDIMessage::NoteOff["C2"].new(0, 100)
            end

            should "create message object" do
              assert_equal(MIDIMessage::NoteOff, @message.class)
              assert_equal("C2", @message.name)
              assert_equal("Note Off: C2", @message.verbose_name)
              assert_equal([0x80, 0x24, 100], @message.to_a)
            end

          end

          context "cc" do

            setup do
              @message = MIDIMessage::ControlChange["Modulation Wheel"].new(2, 0x20)
            end

            should "create message object" do
              assert_equal(MIDIMessage::ControlChange, @message.class)
              assert_equal(@message.channel, 2)
              assert_equal(0x01, @message.index)
              assert_equal(0x20, @message.value)
              assert_equal([0xB2, 0x01, 0x20], @message.to_a)
            end

          end

          context "system realtime" do

            setup do
              @message = MIDIMessage::SystemRealtime["Stop"].new
            end

            should "create message object" do
              assert_equal(MIDIMessage::SystemRealtime, @message.class)
              assert_equal("Stop", @message.name)
              assert_equal([0xFC], @message.to_a)
            end

          end

          context "system common" do

            setup do
              @message = MIDIMessage::SystemCommon["Song Select"].new
            end

            should "create message object" do
              assert_equal(MIDIMessage::SystemCommon, @message.class)
              assert_equal("Song Select", @message.name)
              assert_equal([0xF3], @message.to_a)
            end

          end

        end

      end

    end

  end

end
