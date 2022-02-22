# frozen_string_literal: true

require 'helper'

describe MIDIMessage::SystemMessage do
  describe '#initialize' do
    describe 'common' do
      describe 'normal' do
        let(:message) { MIDIMessage::SystemCommon.new(0x2, 0x00, 0x08) }

        it 'constructs message' do
          expect(message.name).to eq('Song Position Pointer')
          expect(message.status[0]).to eq(0xF)
          expect(message.status[1]).to eq(0x2)
          expect(message.data[0]).to eq(0x00)
          expect(message.data[1]).to eq(0x08)
          expect(message.to_a).to eq([0xF2,0x00, 0x08])
          expect(message.to_bytestr).to eq('F20008')
        end
      end

      describe 'redundant' do
        let(:message) { MIDIMessage::SystemCommon.new(0xF2, 0x00, 0x08) }

        it 'constructs message' do
          expect(message.name).to eq('Song Position Pointer')
          expect(message.status[0]).to eq(0xF)
          expect(message.status[1]).to eq(0x2)
          expect(message.data[0]).to eq(0x00)
          expect(message.data[1]).to eq(0x08)
          expect(message.to_a).to eq([0xF2, 0x00, 0x08])
          expect(message.to_bytestr).to eq('F20008')
        end
      end

      describe 'with constant' do
        let(:message) { MIDIMessage::SystemCommon['Song Position Pointer'].new(0x00, 0x08) }

        it 'constructs message' do
          expect(message.name).to eq('Song Position Pointer')
          expect(message.status[0]).to eq(0xF)
          expect(message.status[1]).to eq(0x2)
          expect(message.data[0]).to eq(0x00)
          expect(message.data[1]).to eq(0x08)
          expect(message.to_a).to eq([0xF2, 0x00, 0x08])
          expect(message.to_bytestr).to eq('F20008')
        end
      end
    end

    describe 'realtime' do
      describe 'normal' do
        let(:message) { MIDIMessage::SystemRealtime.new(0x8) }

        it 'constructs message' do
          expect(message.name).to eq('Clock')
          expect(message.status[0]).to eq(0xF)
          expect(message.status[1]).to eq(0x8)
          expect(message.to_a).to eq([0xF8])
          expect(message.to_bytestr).to eq('F8')
        end
      end

      describe 'redundant' do
        let(:message) { MIDIMessage::SystemRealtime.new(0xF8) }

        it 'constructs message' do
          expect(message.name).to eq('Clock')
          expect(message.status[0]).to eq(0xF)
          expect(message.status[1]).to eq(0x8)
          expect(message.to_a).to eq([0xF8])
          expect(message.to_bytestr).to eq('F8')
        end
      end

      describe 'with constant' do
        let(:message) { MIDIMessage::SystemRealtime['Clock'].new }

        it 'constructs message' do
          expect(message.name).to eq('Clock')
          expect(message.status[0]).to eq(0xF)
          expect(message.status[1]).to eq(0x8)
          expect(message.to_a).to eq([0xF8])
          expect(message.to_bytestr).to eq('F8')
        end
      end
    end
  end
end
