# frozen_string_literal: true
require 'helper'

describe MIDIMessage::Message do
  describe '#update' do
    describe 'note' do
      let(:message) { MIDIMessage::NoteOn['E4'].new(0, 100) }

      it 'is mutable' do
        expect(message.note).to eq(0x40)
        expect(message.name).to eq('E4')

        message.note += 5

        expect(message.note).to eq(0x45)
        expect(message.name).to eq('A4')
      end
    end

    describe 'octave' do
      let(:message) { MIDIMessage::NoteOn['E4'].new(0, 100) }

      it 'is mutable' do
        expect(message.note).to eq(0x40)
        expect(message.name).to eq('E4')

        message.octave += 1

        expect(message.note).to eq(0x4C)
        expect(message.name).to eq('E5')
      end
    end
  end
end
