# frozen_string_literal: true

require 'helper'

describe MIDIMessage::Context do
  describe '.with' do
    describe 'note off' do
      let(:message) do
        MIDIMessage.with(channel: 0, velocity: 64) do
          note_off(55)
        end
      end

      it 'creates message object' do
        expect(message.channel).to eq(0)
        expect(message.note).to eq(55)
        expect(message.velocity).to eq(64)
        expect(message.to_a).to eq([128, 55, 64])
        expect(message.to_bytestr).to eq('803740')
      end
    end

    describe 'note on' do
      let(:message) do
        MIDIMessage.with(channel: 0, velocity: 64) do
          note_on(55)
        end
      end

      it 'creates message object' do
        expect(message.channel).to eq(0)
        expect(message.note).to eq(55)
        expect(message.velocity).to eq(64)
        expect(message.to_a).to eq([144, 55, 64])
        expect(message.to_bytestr).to eq('903740')
      end
    end

    describe 'cc' do
      let(:message) do
        MIDIMessage::Context.with(channel: 2) do
          control_change(0x20, 0x30)
        end
      end

      it 'creates message object' do
        expect(message.channel).to eq(2)
        expect(message.index).to eq(0x20)
        expect(message.value).to eq(0x30)
        expect(message.to_a).to eq([0xB2, 0x20, 0x30])
        expect(message.to_bytestr).to eq('B22030')
      end
    end

    describe 'polyphonic aftertouch' do
      let(:message) do
        MIDIMessage::Context.with(channel: 1) do
          polyphonic_aftertouch(0x40, 0x40)
        end
      end

      it 'creates message object' do
        expect(message.channel).to eq(1)
        expect(message.note).to eq(0x40)
        expect(message.value).to eq(0x40)
        expect(message.to_a).to eq([0xA1, 0x40, 0x40])
        expect(message.to_bytestr).to eq('A14040')
      end
    end

    describe 'program change' do
      let(:message) do
        MIDIMessage.with(channel: 3) do
          program_change(0x40)
        end
      end

      it 'creates message object' do
        expect(message.channel).to eq(3)
        expect(message.program).to eq(0x40)
        expect(message.to_a).to eq([0xC3, 0x40])
        expect(message.to_bytestr).to eq('C340')
      end
    end

    describe 'channel aftertouch' do
      let(:message) do
        MIDIMessage.with(channel: 3) do
          channel_aftertouch(0x50)
        end
      end

      it 'creates message object' do
        expect(message.channel).to eq(3)
        expect(message.value).to eq(0x50)
        expect(message.to_a).to eq([0xD3, 0x50])
        expect(message.to_bytestr).to eq('D350')
      end
    end

    describe 'pitch bend' do
      let(:message) do
        MIDIMessage.with(channel: 0) do
          pitch_bend(0x50, 0xA0)
        end
      end

      it 'creates message object' do
        expect(message.channel).to eq(0)
        expect(message.low).to eq(0x50)
        expect(message.high).to eq(0xA0)
        expect(message.to_a).to eq([0xE0, 0x50, 0xA0])
        expect(message.to_bytestr).to eq('E050A0')
      end
    end
  end
end
