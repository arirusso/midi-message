require "helper"

class MIDIMessage::ContextTest < Minitest::Test

  context "Context" do

    context ".with" do

      context "note off" do

        setup do
          @message = MIDIMessage.with(:channel => 0, :velocity => 64) do
            note_off(55)
          end
        end

        should "create message object" do
          assert_equal(0, @message.channel)
          assert_equal(55, @message.note)
          assert_equal(64, @message.velocity)
          assert_equal([128, 55, 64], @message.to_a)
          assert_equal("803740", @message.to_bytestr)
        end

      end

      context "note on" do

        setup do
          @message = MIDIMessage.with(:channel => 0, :velocity => 64) do
            note_on(55)
          end
        end

        should "create message object" do
          assert_equal(0, @message.channel)
          assert_equal(55, @message.note)
          assert_equal(64, @message.velocity)
          assert_equal([144, 55, 64], @message.to_a)
          assert_equal("903740", @message.to_bytestr)
        end

      end

      context "cc" do

        setup do
          @message = MIDIMessage::Context.with(:channel => 2) do
            control_change(0x20, 0x30)
          end
        end

        should "create message object" do
          assert_equal(@message.channel, 2)
          assert_equal(0x20, @message.index)
          assert_equal(0x30, @message.value)
          assert_equal([0xB2, 0x20, 0x30], @message.to_a)
          assert_equal("B22030", @message.to_bytestr)
        end

      end

      context "polyphonic aftertouch" do

        setup do
          @message = MIDIMessage::Context.with(:channel => 1) do
            polyphonic_aftertouch(0x40, 0x40)
          end
        end

        should "create message object" do
          assert_equal(1, @message.channel)
          assert_equal(0x40, @message.note)
          assert_equal(0x40, @message.value)
          assert_equal([0xA1, 0x40, 0x40], @message.to_a)
          assert_equal("A14040", @message.to_bytestr)
        end

      end

      context "program change" do

        setup do
          @message = MIDIMessage.with(:channel => 3) do
            program_change(0x40)
          end
        end

        should "create message object" do
          assert_equal(3, @message.channel)
          assert_equal(0x40, @message.program)
          assert_equal([0xC3, 0x40], @message.to_a)
          assert_equal("C340", @message.to_bytestr)
        end

      end

      context "channel aftertouch" do

        setup do
          @message = MIDIMessage.with(:channel => 3) do
            channel_aftertouch(0x50)
          end
        end

        should "create message object" do
          assert_equal(3, @message.channel)
          assert_equal(0x50, @message.value)
          assert_equal([0xD3, 0x50], @message.to_a)
          assert_equal("D350", @message.to_bytestr)
        end

      end

      context "pitch bend" do

        setup do
          @message = MIDIMessage.with(:channel => 0) do
            pitch_bend(0x50, 0xA0)
          end
        end

        should "create message object" do
          assert_equal(0, @message.channel)
          assert_equal(0x50, @message.low)
          assert_equal(0xA0, @message.high)
          assert_equal([0xE0, 0x50, 0xA0], @message.to_a)
          assert_equal("E050A0", @message.to_bytestr)
        end

      end

    end

  end

end
