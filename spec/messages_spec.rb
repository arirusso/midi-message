# frozen_string_literal: true
require 'helper'

describe 'messages' do
  describe MIDIMessage::ChannelMessage do
    let(:message) { MIDIMessage::ChannelMessage.new(0x9, 0x0, 0x40, 0x40) }
    let(:typed_message) { message.to_type }

    describe 'initialize' do
      it 'builds message object' do
        expect(message).to be_a(MIDIMessage)
        expect(message.status[0]).to eq(0x9)
        expect(message.status[1]).to eq(0x0)
        expect(message.data[0]).to eq(0x40)
        expect(message.data[1]).to eq(0x40)
        expect(message.to_a).to eq([0x90, 0x40, 0x40])
        expect(message.to_bytestr).to eq('904040')
      end
    end

    describe '#to_type' do
      it 'builds subclassed message object' do
        expect(typed_message).to be_a(MIDIMessage::NoteOn)
        expect(typed_message.channel).to eq(message.status[1])
        expect(typed_message.note).to eq(message.data[0])
        expect(typed_message.velocity).to eq(message.data[1])
        expect(typed_message.to_a).to eq(message.to_a)
        expect(typed_message.to_bytestr).to eq(message.to_bytestr)
      end
    end
  end

  describe MIDIMessage::NoteOff do
    let(:message) { MIDIMessage::NoteOff.new(0, 0x40, 0x40) }

    it 'builds message' do
      expect(message.channel).to eq(0)
      expect(message.note).to eq(0x40)
      expect(message.velocity).to eq(0x40)
      expect(message.to_a).to eq([0x80, 0x40, 0x40])
      expect(message.to_bytestr).to eq('804040')
    end
  end

  describe MIDIMessage::NoteOn do
    let(:message) { MIDIMessage::NoteOn.new(1, 0x40, 0x40) }

    describe 'initialize' do
      it 'builds message' do
        expect(message.channel).to eq(1)
        expect(message.note).to eq(0x40)
        expect(message.velocity).to eq(0x40)
        expect(message.to_a).to eq([0x91, 0x40, 0x40])
        expect(message.to_bytes).to eq([0x91, 0x40, 0x40])
        expect(message.to_bytestr).to eq('914040')
      end
    end

    describe 'NoteOn#channel=' do
      it 'changes channel' do
        expect(message.channel).to eq(1)
        expect(message.to_bytes).to eq([0x91, 0x40, 0x40])

        message.channel = 3
        expect(message.channel).to eq(3)
        expect(message.note).to eq(0x40)
        expect(message.velocity).to eq(0x40)
        expect(message.to_a).to eq([0x93, 0x40, 0x40])
        expect(message.to_bytes).to eq([0x93, 0x40, 0x40])
        expect(message.to_bytestr).to eq('934040')
      end
    end

    describe 'NoteOn#to_note_off' do
      it 'returns initialized note off message' do
        expect(message.channel).to eq(1)
        expect(message.to_bytes).to eq([0x91, 0x40, 0x40])

        off_message = message.to_note_off
        expect(off_message.channel).to eq(1)
        expect(off_message.note).to eq(0x40)
        expect(off_message.velocity).to eq(0x40)
        expect(off_message.to_a).to eq([0x81, 0x40, 0x40])
      end
    end
  end

  describe MIDIMessage::PolyphonicAftertouch do
    let(:message) { MIDIMessage::PolyphonicAftertouch.new(1, 0x40, 0x40) }

    it 'builds message' do
      expect(message.channel).to eq(1)
      expect(message.note).to eq(0x40)
      expect(message.value).to eq(0x40)
      expect(message.to_a).to eq([0xA1, 0x40, 0x40])
      expect(message.to_bytestr).to eq('A14040')
    end
  end

  describe MIDIMessage::ControlChange do
    let(:message) { MIDIMessage::ControlChange.new(2, 0x20, 0x20) }

    it 'builds message' do
      expect(message.channel).to eq(2)
      expect(message.index).to eq(0x20)
      expect(message.value).to eq(0x20)
      expect(message.to_a).to eq([0xB2, 0x20, 0x20])
      expect(message.to_bytestr).to eq('B22020')
    end
  end

  describe MIDIMessage::ProgramChange do
    let(:message) { MIDIMessage::ProgramChange.new(3, 0x40) }

    it 'builds message' do
      expect(message.channel).to eq(3)
      expect(message.program).to eq(0x40)
      expect(message.to_a).to eq([0xC3, 0x40])
      expect(message.to_bytestr).to eq('C340')
    end
  end
  describe MIDIMessage::ChannelAftertouch do
    let(:message) { MIDIMessage::ChannelAftertouch.new(3, 0x50) }

    it 'builds message' do
      expect(message.channel).to eq(3)
      expect(message.value).to eq(0x50)
      expect(message.to_a).to eq([0xD3, 0x50])
      expect(message.to_bytestr).to eq('D350')
    end
  end
  describe MIDIMessage::PitchBend do
    let(:message) { MIDIMessage::PitchBend.new(0, 0x50, 0xA0) }

    it 'builds message' do
      expect(message.channel).to eq(0)
      expect(message.low).to eq(0x50)
      expect(message.high).to eq(0xA0)
      expect(message.to_a).to eq([0xE0, 0x50, 0xA0])
      expect(message.to_bytestr).to eq('E050A0')
    end
  end
  describe MIDIMessage::SystemCommon do
    let(:message) { MIDIMessage::SystemCommon.new(1, 0x50, 0xA0) }

    it 'builds message' do
      expect(message.status[1]).to eq(1)
      expect(message.data[0]).to eq(0x50)
      expect(message.data[1]).to eq(0xA0)
      expect(message.to_a).to eq([0xF1, 0x50, 0xA0])
      expect(message.to_bytestr).to eq('F150A0')
    end
  end
  describe MIDIMessage::SystemRealtime do
    let(:message) { MIDIMessage::SystemRealtime.new(0x8) }

    it 'builds message' do
      expect(message.id).to eq(8)
      expect(message.to_a).to eq([0xF8])
      expect(message.to_bytestr).to eq('F8')
    end
  end
end
