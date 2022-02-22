# frozen_string_literal: true

require 'helper'

describe MIDIMessage::Constant do
  describe '.find' do
    let(:map) { MIDIMessage::Constant.find(:note, 'C2') }

    it 'returns constant mapping' do
      expect(map).to_not be_nil
      expect(map).to be_a(MIDIMessage::Constant::Map)
      expect(map.value).to eq(36)
    end
  end

  describe '.value' do
    let(:value) { MIDIMessage::Constant.value(:note, 'C3') }

    it 'returns constant value' do
      expect(value).to_not be_nil
      expect(value).to eq(48)
      expect(value).to eq(MIDIMessage::NoteOn.new(0, value, 100).note)
      expect(value).to eq(MIDIMessage::NoteOn['C3'].new(0, 100).note)
    end
  end

  describe 'Name' do
    describe '.underscore' do
      let(:result) { MIDIMessage::Constant::Name.underscore('Control Change') }

      it 'converts string' do
        expect(result).to_not be_nil
        expect(result).to eq('control_change')
      end
    end

    describe '.match?' do
      it 'matches string' do
        expect(MIDIMessage::Constant::Name.match?('Control Change', :control_change)).to be(true)
        expect(MIDIMessage::Constant::Name.match?('Note', :note)).to be(true)
        expect(MIDIMessage::Constant::Name.match?('System Common', :system_common)).to be(true)
      end
    end
  end

  describe 'Group' do
    describe '#find' do
      let(:group) { MIDIMessage::Constant::Group.find(:note) }
      let(:map) { group.find('C3') }

      it 'returns correct mapping' do
        expect(map).to_not be_nil
        expect(map).to be_a(MIDIMessage::Constant::Map)
        expect(map.value).to eq(48)
      end
    end

    describe '.find' do
      let(:group) { MIDIMessage::Constant::Group.find(:note) }

      it 'returns group object' do
        expect(group).to_not be_nil
        expect(group).to be_a(MIDIMessage::Constant::Group)
        expect(group.key).to eq('Note')
        expect(group.constants).to_not be_empty
        expect(group.constants.all? { |c| c.kind_of?(MIDIMessage::Constant::Map) }).to be(true)
      end
    end
  end

  describe 'MessageBuilder' do
    describe '#new' do
      describe 'note on' do
        let(:group) { MIDIMessage::Constant::Group.find(:note) }
        let(:map) { group.find('C3') }
        let(:builder) { MIDIMessage::Constant::MessageBuilder.new(MIDIMessage::NoteOn, map) }
        let(:note) { builder.new }

        it 'builds correct note' do
          expect(note).to_not be_nil
          expect(note.name).to eq('C3')
        end
      end

      describe 'cc' do
        let(:group) { MIDIMessage::Constant::Group.find(:control_change) }
        let(:map) { group.find('Modulation Wheel') }
        let(:builder) { MIDIMessage::Constant::MessageBuilder.new(MIDIMessage::ControlChange, map) }
        let(:cc) { builder.new }

        it 'builds correct cc' do
          expect(cc).to_not be_nil
          expect(cc.name).to eq('Modulation Wheel')
        end
      end
    end
  end

  describe 'Status' do
    describe '.find' do
      it 'finds status' do
        expect(MIDIMessage::Constant::Status.find('Note Off')).to eq(0x8)
        expect(MIDIMessage::Constant::Status.find('Note On')).to eq(0x9)
        expect(MIDIMessage::Constant::Status['Control Change']).to eq(0xB)
      end
    end
  end

  describe 'Loader' do
    describe 'DSL' do
      describe '.find' do
        describe 'note on' do
          let(:message) { MIDIMessage::NoteOn['c3'].new(0, 100) }

          it 'creates message object' do
            expect(message).to be_a(MIDIMessage::NoteOn)
            expect(message.name).to eq('C3')
            expect(message.note_name).to eq('C')
            expect(message.verbose_name).to eq('Note On: C3')
            expect(message.to_a).to eq([0x90, 0x30, 100])
          end
        end

        describe 'note off' do
          let(:message) { MIDIMessage::NoteOff['C2'].new(0, 100) }

          it 'creates message object' do
            expect(message).to be_a(MIDIMessage::NoteOff)
            expect(message.name).to eq('C2')
            expect(message.verbose_name).to eq('Note Off: C2')
            expect(message.to_a).to eq([0x80, 0x24, 100])
          end
        end

        describe 'cc' do
          let(:message) { MIDIMessage::ControlChange.find('Modulation Wheel').new(2, 0x20) }

          it 'creates message object' do
            expect(message).to be_a(MIDIMessage::ControlChange)
            expect(message.channel).to eq(2)
            expect(message.index).to eq(0x01)
            expect(message.value).to eq(0x20)
            expect(message.to_a).to eq([0xB2, 0x01, 0x20])
          end
        end

        describe 'system realtime' do
          let(:message) { MIDIMessage::SystemRealtime['Stop'].new }

          it 'creates message object' do
            expect(message).to be_a(MIDIMessage::SystemRealtime)
            expect(message.name).to eq('Stop')
            expect(message.to_a).to eq([0xFC])
          end
        end

        describe 'system common' do
          let(:message) { MIDIMessage::SystemCommon['Song Select'].new }

          it 'creates message object' do
            expect(message).to be_a(MIDIMessage::SystemCommon)
            expect(message.name).to eq('Song Select')
            expect(message.to_a).to eq([0xF3])
          end
        end
      end
    end
  end
end
