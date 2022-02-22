# frozen_string_literal: true

require 'helper'

describe MIDIMessage::Parser do
  describe MIDIMessage::SystemExclusive do
    let(:message) { MIDIMessage.parse(0xF0, 0x41, 0x10, 0x42, 0x12, 0x40, 0x00, 0x7F, 0x00, 0x41, 0xF7) }

    it 'parses message' do
      expect(message).to be_a(MIDIMessage::SystemExclusive::Command)
      expect(message.node).to be_a(MIDIMessage::SystemExclusive::Node)
      expect(message.address).to eq([0x40, 0x00, 0x7F])
      expect(message.to_bytes).to eq([0xF0, 0x41, 0x10, 0x42, 0x12, 0x40, 0x00, 0x7F, 0x00, 0x41, 0xF7])
    end
  end

  describe MIDIMessage::NoteOff do
    let(:message) { MIDIMessage.parse(0x80, 0x40, 0x40) }

    it 'parses message' do
      expect(message).to be_a(MIDIMessage::NoteOff)
      expect(message.to_a).to eq([0x80, 0x40, 0x40])
    end
  end

  describe MIDIMessage::NoteOn do
    let(:message) { MIDIMessage.parse(0x90, 0x40, 0x40) }

    it 'parses message' do
      expect(message).to be_a(MIDIMessage::NoteOn)
      expect(message.to_a).to eq([0x90, 0x40, 0x40])
    end
  end

  describe MIDIMessage::PolyphonicAftertouch do
    let(:message) { MIDIMessage.parse(0xA1, 0x40, 0x40) }

    it 'parses message' do
      expect(message).to be_a(MIDIMessage::PolyphonicAftertouch)
      expect(message.to_a).to eq([0xA1, 0x40, 0x40])
    end
  end

  describe MIDIMessage::ControlChange do
    let(:message) { MIDIMessage.parse(0xB2, 0x20, 0x20) }

    it 'parses message' do
      expect(message).to be_a(MIDIMessage::ControlChange)
      expect(message.to_a).to eq([0xB2, 0x20, 0x20])
    end
  end

  describe MIDIMessage::ProgramChange do
    let(:message) { MIDIMessage.parse(0xC3, 0x40) }

    it 'parses message' do
      expect(message).to be_a(MIDIMessage::ProgramChange)
      expect(message.to_bytestr).to eq('C340')
    end
  end

  describe MIDIMessage::ChannelAftertouch do
    let(:message) { MIDIMessage.parse('D350') }

    it 'parses message' do
      expect(message).to be_a(MIDIMessage::ChannelAftertouch)
      expect(message.to_a).to eq([0xD3, 0x50])
    end
  end

  describe MIDIMessage::PitchBend do
    let(:message) { MIDIMessage.parse('E050A0') }

    it 'parses message' do
      expect(message).to be_a(MIDIMessage::PitchBend)
      expect(message.to_a).to eq([0xE0, 0x50, 0xA0])
    end
  end

  describe MIDIMessage::SystemCommon do
    let(:message) { MIDIMessage.parse([0xF1, 0x50, 0xA0]) }

    it 'parses message' do
      expect(message).to be_a(MIDIMessage::SystemCommon)
      expect(message.to_a).to eq([0xF1, 0x50, 0xA0])
    end
  end

  describe MIDIMessage::SystemRealtime do
    let(:message) { MIDIMessage.parse(0xF8) }

    it 'parses message' do
      expect(message).to be_a(MIDIMessage::SystemRealtime)
      expect(message.to_a).to eq([0xF8])
    end
  end
end
