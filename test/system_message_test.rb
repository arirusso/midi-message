require "helper"

class MIDIMessage::SystemMessageTest < Minitest::Test

  context "SystemMessage" do

    context "#initialize" do

      context "common" do

        context "normal" do

          should "construct message" do
            @message = MIDIMessage::SystemCommon.new(0x2, 0x00, 0x08)
            assert_equal("Song Position Pointer", @message.name)
            assert_equal(0xF, @message.status[0])
            assert_equal(0x2, @message.status[1])
            assert_equal(0x00, @message.data[0])
            assert_equal(0x08, @message.data[1])
            assert_equal([0xF2, 0x00, 0x08], @message.to_a)
            assert_equal("F20008", @message.to_bytestr)
          end

        end

        context "redundant" do

          should "construct message" do
            @message = MIDIMessage::SystemCommon.new(0xF2, 0x00, 0x08)
            assert_equal("Song Position Pointer", @message.name)
            assert_equal(0xF, @message.status[0])
            assert_equal(0x2, @message.status[1])
            assert_equal(0x00, @message.data[0])
            assert_equal(0x08, @message.data[1])
            assert_equal([0xF2, 0x00, 0x08], @message.to_a)
            assert_equal("F20008", @message.to_bytestr)
          end

        end

        context "with constant" do

          should "construct message" do
            @message = MIDIMessage::SystemCommon["Song Position Pointer"].new(0x00, 0x08)
            assert_equal("Song Position Pointer", @message.name)
            assert_equal(0xF, @message.status[0])
            assert_equal(0x2, @message.status[1])
            assert_equal(0x00, @message.data[0])
            assert_equal(0x08, @message.data[1])
            assert_equal([0xF2, 0x00, 0x08], @message.to_a)
            assert_equal("F20008", @message.to_bytestr)
          end

        end

      end

      context "realtime" do

        context "normal" do

          should "construct message" do
            @message = MIDIMessage::SystemRealtime.new(0x8)
            assert_equal("Clock", @message.name)
            assert_equal(0xF, @message.status[0])
            assert_equal(0x8, @message.status[1])
            assert_equal([0xF8], @message.to_a)
            assert_equal("F8", @message.to_bytestr)
          end

        end

        context "redundant" do

          should "construct message" do
            @message = MIDIMessage::SystemRealtime.new(0xF8)
            assert_equal("Clock", @message.name)
            assert_equal(0xF, @message.status[0])
            assert_equal(0x8, @message.status[1])
            assert_equal([0xF8], @message.to_a)
            assert_equal("F8", @message.to_bytestr)
          end

        end

        context "with constant" do

          should "construct message" do
            @message = MIDIMessage::SystemRealtime["Clock"].new
            assert_equal("Clock", @message.name)
            assert_equal(0xF, @message.status[0])
            assert_equal(0x8, @message.status[1])
            assert_equal([0xF8], @message.to_a)
            assert_equal("F8", @message.to_bytestr)
          end

        end

      end

    end

  end

end
