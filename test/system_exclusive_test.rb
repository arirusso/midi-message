require "helper"

class SystemExclusiveMessageTest < Minitest::Test

  context "SystemExclusive" do

    context "Node" do

      context "#initialize" do

        setup do
          @node = MIDIMessage::SystemExclusive::Node.new(0x41, :model_id => 0x42, :device_id => 0x10)
        end

        should "populate message" do
          assert_equal(0x41, @node.manufacturer_id)
          assert_equal(0x42, @node.model_id)
          assert_equal(0x10, @node.device_id)
        end

      end

      context "#request" do

        setup do
          @node = MIDIMessage::SystemExclusive::Node.new(0x41, :model_id => 0x42, :device_id => 0x10)
          @message = @node.request([0x40, 0x7F, 0x00], 0x10)
        end

        should "build correct request message object" do
          assert_equal(@node, @message.node)
          assert_equal([0x40, 0x7F, 0x00], @message.address)
          assert_equal([0x0, 0x0, 0x10], @message.size)
        end

      end

      context "#manufacturer_id" do

        setup do
          @node = MIDIMessage::SystemExclusive::Node.new(:Roland, :model_id => 0x42, :device_id => 0x10)
        end

        should "populate manufacturer id from constant" do
          assert_equal(0x41, @node.manufacturer_id)
          assert_equal(0x42, @node.model_id)
          assert_equal(0x10, @node.device_id)
          assert_equal([0x41, 0x10, 0x42], @node.to_a)
        end

      end

      context "#model_id" do

        context "nil" do

          setup do
            @node = MIDIMessage::SystemExclusive::Node.new(:Roland, :device_id => 0x10)
            @message = MIDIMessage::SystemExclusive::Command.new([0x40, 0x7F, 0x00], 0x10, :node => @node)
          end

          should "create node with nil model_id" do
            assert_equal(0x41, @node.manufacturer_id)
            assert_equal(nil, @node.model_id)
            assert_equal(0x10, @node.device_id)
            assert_equal([0x41, 0x10], @node.to_a)
          end

          should "associate node with message" do
            assert_equal(10, @message.to_bytes.size)
            assert_equal([0xF0, 0x41, 0x10, 0x12, 0x40, 0x7F, 0x00, 0x10, 0x31, 0xF7], @message.to_bytes)
          end

        end

      end

      context "#new_message_from" do

        setup do
          @prototype = MIDIMessage::SystemExclusive::Request.new([0x40, 0x7F, 0x00], 0x10)
          @node = MIDIMessage::SystemExclusive::Node.new(0x41, :model_id => 0x42, :device_id => 0x10)
          @message = @node.new_message_from(@prototype)
        end

        should "create clone of original request" do
          refute_nil(@message)
          refute_equal(@prototype, @message)
          assert_equal(@node, @message.node)
          assert_equal(@prototype.address, @message.address)
          assert_equal(@prototype.size, @message.size)
        end

      end

    end

    context "Command" do

      context "#initialize" do

        context "with node" do

          setup do
            @node = MIDIMessage::SystemExclusive::Node.new(0x41, :model_id => 0x42, :device_id => 0x10)
            @message = MIDIMessage::SystemExclusive::Command.new([0x40, 0x7F, 0x00], 0x10, :node => @node)
          end

          should "create message and associate with node" do
            assert_equal(@node, @message.node)
            assert_equal([0x40, 0x7F, 0x00], @message.address)
            assert_equal(0x10, @message.data)
          end

        end

        context "without node" do

          setup do
            @message = MIDIMessage::SystemExclusive::Command.new([0x40, 0x7F, 0x00], 0x10)
          end

          should "populate message" do
            assert_equal([0xF0, 0x12, 0x40, 0x7F, 0x00, 0x10, 0x31, 0xF7], @message.to_bytes)
          end

        end

      end

      context "#checksum" do

        setup do
          @node = MIDIMessage::SystemExclusive::Node.new(0x41, :model_id => 0x42, :device_id => 0x10)
          @message = MIDIMessage::SystemExclusive::Command.new([0x40, 0x00, 0x7F], 0x00, :node => @node)
        end

        should "have correct checksum" do
          assert_equal(0x41, @message.checksum)
        end

      end

      context "#to_a" do

        setup do
          @node = MIDIMessage::SystemExclusive::Node.new(0x41, :model_id => 0x42, :device_id => 0x10)
          @message = MIDIMessage::SystemExclusive::Command.new([0x40, 0x00, 0x7F], 0x00, :node => @node)
        end

        should "have correct data in bytes" do
          assert_equal([0xF0, 0x41, 0x10, 0x42, 0x12, 0x40, 0x00, 0x7F, 0x00, 0x41, 0xF7], @message.to_bytes)
        end

      end

      context "#to_s" do

        setup do
          @node = MIDIMessage::SystemExclusive::Node.new(0x41, :model_id => 0x42, :device_id => 0x10)
          @message = MIDIMessage::SystemExclusive::Command.new([0x40, 0x00, 0x7F], 0x00, :node => @node)
        end

        should "have correct data as hex string" do
          assert_equal("F04110421240007F0041F7", @message.to_bytestr)
        end

      end

    end

    context "Request" do

      context "#size" do

        setup do
          @node = MIDIMessage::SystemExclusive::Node.new(0x41, :model_id => 0x42, :device_id => 0x10)
        end

        context "array" do

          setup do
            @message = MIDIMessage::SystemExclusive::Request.new([0x40, 0x7F, 0x00], [0x0, 0x9, 0x10], :node => @node)
          end

          should "should have correct size data" do
            assert_equal(@node, @message.node)
            assert_equal([0x40, 0x7F, 0x00], @message.address)
            assert_equal([0x0, 0x9, 0x10], @message.size)
          end

        end

        context "byte" do

          setup do
            @message = MIDIMessage::SystemExclusive::Request.new([0x40, 0x7F, 0x00], 0x10, :node => @node)
          end

          should "should have correct size data" do
            assert_equal(@node, @message.node)
            assert_equal([0x40, 0x7F, 0x00], @message.address)
            assert_equal([0x0, 0x0, 0x10], @message.size)
          end

        end

        context "numeric" do

          setup do
            @message = MIDIMessage::SystemExclusive::Request.new([0x40, 0x7F, 0x00], 300, :node => @node)
          end

          should "should have correct size data" do
            assert_equal(@node, @message.node)
            assert_equal([0x40, 0x7F, 0x00], @message.address)
            assert_equal([0x0, 0x35, 0xF7], @message.size)
          end

        end

      end

    end

    context "Builder" do

      context ".build" do

        context "normal message" do

          setup do
            @message = MIDIMessage::SystemExclusive::Builder.build(0xF0, 0x41, 0x10, 0x42, 0x12, 0x40, 0x00, 0x7F, 0x10, 0x41, 0xF7)
          end

          should "create message" do
            assert_equal(0x41, @message.node.manufacturer_id)
            assert_equal(0x42, @message.node.model_id)
            assert_equal(0x10, @message.node.device_id)
            assert_equal([0x40, 0x00, 0x7F], @message.address)
            assert_equal(0x10, @message.data)
          end

        end

        context "weird message" do

          setup do
            @message = MIDIMessage::SystemExclusive::Builder.build(0xF0, 0x41, 0x12, 0x40, 0x00, 0x7F, 0x10, 0x41, 0xF7)
          end

          should "create message" do
            assert_equal([0x41, 0x12, 0x40, 0x00, 0x7F, 0x10, 0x41], @message.data)
            assert_equal([0xF0, 0x41, 0x12, 0x40, 0x00, 0x7F, 0x10, 0x41, 0xF7], @message.to_bytes)
          end

        end

      end

    end

  end

end
