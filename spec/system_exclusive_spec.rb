# frozen_string_literal: true

require 'helper'

describe MIDIMessage::SystemExclusive do
  describe 'Node' do
    describe '#initialize' do
      let(:node) { MIDIMessage::SystemExclusive::Node.new(0x41, model_id: 0x42, device_id: 0x10) }

      it 'populates message' do
        expect(node.manufacturer_id).to eq(0x41)
        expect(node.model_id).to eq(0x42)
        expect(node.device_id).to eq(0x10)
      end
    end

    describe '#request' do
      let(:node) { MIDIMessage::SystemExclusive::Node.new(0x41, model_id: 0x42, device_id: 0x10) }
      let(:message) { node.request([0x40, 0x7F, 0x00], 0x10) }

      it 'builds correct request message object' do
        expect(message.node).to eq(node)
        expect(message.address).to eq([0x40, 0x7F, 0x00])
        expect(message.size).to eq([0x0, 0x0, 0x10])
      end
    end

    describe '#manufacturer_id' do
      let(:node) { MIDIMessage::SystemExclusive::Node.new(:Roland, model_id: 0x42, device_id: 0x10) }

      it 'populates manufacturer id from constant' do
        expect(node.manufacturer_id).to eq(0x41)
        expect(node.model_id).to eq(0x42)
        expect(node.device_id).to eq(0x10)
        expect(node.to_a).to eq([0x41, 0x10, 0x42])
      end
    end

    describe '#model_id' do
      describe 'nil' do
        let(:node) { MIDIMessage::SystemExclusive::Node.new(:Roland, device_id: 0x10) }
        let(:message) { MIDIMessage::SystemExclusive::Command.new([0x40, 0x7F, 0x00], 0x10, node: node) }

        it 'creates node with nil model_id' do
          expect(node.manufacturer_id).to eq(0x41)
          expect(node.model_id).to be_nil
          expect(node.device_id).to eq(0x10)
          expect(node.to_a).to eq([0x41, 0x10])
        end

        it 'associates node with message' do
          expect(message.to_bytes.size).to eq(10)
          expect(message.to_bytes).to eq([0xF0, 0x41, 0x10, 0x12, 0x40, 0x7F, 0x00, 0x10, 0x31, 0xF7])
        end
      end
    end

    describe '#new_message_from' do
      let(:prototype) { MIDIMessage::SystemExclusive::Request.new([0x40, 0x7F, 0x00], 0x10) }
      let(:node) { MIDIMessage::SystemExclusive::Node.new(0x41, model_id: 0x42, device_id: 0x10) }
      let(:message) { node.new_message_from(prototype) }

      it 'creates clone of original request' do
        expect(message).to_not be_nil
        expect(message).to_not eq(prototype)
        expect(message.node).to eq(node)
        expect(message.address).to eq(prototype.address)
        expect(message.size).to eq(prototype.size)
      end
    end
  end

  describe 'Command' do
    describe '#initialize' do
      describe 'with node' do
        let(:node) { MIDIMessage::SystemExclusive::Node.new(0x41, model_id: 0x42, device_id: 0x10) }
        let(:message) { MIDIMessage::SystemExclusive::Command.new([0x40, 0x7F, 0x00], 0x10, node: node) }

        it 'creates message and associate with node' do
          expect(message.node).to eq(node)
          expect(message.address).to eq([0x40, 0x7F, 0x00])
          expect(message.data).to eq(0x10)
        end
      end

      describe 'without node' do
        let(:message) { MIDIMessage::SystemExclusive::Command.new([0x40, 0x7F, 0x00], 0x10) }

        it 'populates message' do
          expect(message.to_bytes).to eq([0xF0, 0x12, 0x40, 0x7F, 0x00, 0x10, 0x31, 0xF7])
        end
      end
    end

    describe '#checksum' do
      let(:node) { MIDIMessage::SystemExclusive::Node.new(0x41, model_id: 0x42, device_id: 0x10) }
      let(:message) { MIDIMessage::SystemExclusive::Command.new([0x40, 0x00, 0x7F], 0x00, node: node) }

      it 'has correct checksum' do
        expect(message.checksum).to eq(0x41)
      end
    end

    describe '#to_a' do
      let(:node) { MIDIMessage::SystemExclusive::Node.new(0x41, model_id: 0x42, device_id: 0x10) }
      let(:message) { MIDIMessage::SystemExclusive::Command.new([0x40, 0x00, 0x7F], 0x00, node: node) }

      it 'has correct data in bytes' do
        expect(message.to_bytes).to eq([0xF0, 0x41, 0x10, 0x42, 0x12, 0x40, 0x00, 0x7F, 0x00, 0x41, 0xF7])
      end
    end

    describe '#to_s' do
      let(:node) { MIDIMessage::SystemExclusive::Node.new(0x41, model_id: 0x42, device_id: 0x10) }
      let(:message) { MIDIMessage::SystemExclusive::Command.new([0x40, 0x00, 0x7F], 0x00, node: node) }

      it 'has correct data as hex string' do
        expect(message.to_bytestr).to eq('F04110421240007F0041F7')
      end
    end
  end

  describe 'Request' do
    describe '#size' do
      let(:node) { MIDIMessage::SystemExclusive::Node.new(0x41, model_id: 0x42, device_id: 0x10) }

      describe 'array' do
        let(:message) { MIDIMessage::SystemExclusive::Request.new([0x40, 0x7F, 0x00], [0x0, 0x9, 0x10], node: node) }

        it 'should have correct size data' do
          expect(message.node).to eq(node)
          expect(message.address).to eq([0x40, 0x7F, 0x00])
          expect(message.size).to eq([0x0, 0x9, 0x10])
        end
      end

      describe 'byte' do
        let(:message) { MIDIMessage::SystemExclusive::Request.new([0x40, 0x7F, 0x00], 0x10, node: node) }

        it 'should have correct size data' do
          expect(message.node).to eq(node)
          expect(message.address).to eq([0x40, 0x7F, 0x00])
          expect(message.size).to eq([0x0, 0x0, 0x10])
        end
      end

      describe 'numeric' do
        let(:message) { MIDIMessage::SystemExclusive::Request.new([0x40, 0x7F, 0x00], 300, node: node) }

        it 'should have correct size data' do
          expect(message.node).to eq(node)
          expect(message.address).to eq([0x40, 0x7F, 0x00])
          expect(message.size).to eq([0x0, 0x35, 0xF7])
        end
      end
    end
  end

  describe 'Builder' do
    describe '.build' do
      describe 'normal message' do
        let(:message) do
          MIDIMessage::SystemExclusive::Builder.build(0xF0, 0x41, 0x10, 0x42, 0x12, 0x40, 0x00, 0x7F,
                                                      0x10, 0x41, 0xF7)
        end

        it 'creates message' do
          expect(message.node.manufacturer_id).to eq(0x41)
          expect(message.node.model_id).to eq(0x42)
          expect(message.node.device_id).to eq(0x10)
          expect(message.address).to eq([0x40, 0x00, 0x7F])
          expect(message.data).to eq(0x10)
        end
      end

      describe 'weird message' do
        let(:message) do
          MIDIMessage::SystemExclusive::Builder.build(0xF0, 0x41, 0x12, 0x40, 0x00, 0x7F, 0x10, 0x41,
                                                      0xF7)
        end

        it 'creates message' do
          expect(message.data).to eq([0x41, 0x12, 0x40, 0x00, 0x7F, 0x10, 0x41])
          expect(message.to_bytes).to eq([0xF0, 0x41, 0x12, 0x40, 0x00, 0x7F, 0x10, 0x41, 0xF7])
        end
      end
    end
  end
end
