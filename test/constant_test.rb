# frozen_string_literal: true

require 'helper'

module MIDIMessage
  class ConstantTest < Minitest::Test
    context 'Constant' do
      context '.find' do
        setup do
          @map = MIDIMessage::Constant.find(:note, 'C2')
        end

        should 'return constant mapping' do
          refute_nil @map
          assert_equal MIDIMessage::Constant::Map, @map.class
          assert_equal 36, @map.value
        end
      end

      context '.value' do
        setup do
          @value = MIDIMessage::Constant.value(:note, 'C3')
        end

        should 'return constant value' do
          refute_nil @value
          assert_equal 48, @value
          assert_equal MIDIMessage::NoteOn.new(0, @value, 100).note, @value
          assert_equal MIDIMessage::NoteOn['C3'].new(0, 100).note, @value
        end
      end

      context 'Name' do
        context '.underscore' do
          should 'convert string' do
            @result = MIDIMessage::Constant::Name.underscore('Control Change')
            refute_nil @result
            assert_equal 'control_change', @result
          end
        end

        context '.match?' do
          should 'match string' do
            assert MIDIMessage::Constant::Name.match?('Control Change', :control_change)
            assert MIDIMessage::Constant::Name.match?('Note', :note)
            assert MIDIMessage::Constant::Name.match?('System Common', :system_common)
          end
        end
      end

      context 'Group' do
        context '#find' do
          setup do
            @group = MIDIMessage::Constant::Group.find(:note)
            @map = @group.find('C3')
          end

          should 'return correct mapping' do
            refute_nil @map
            assert_equal MIDIMessage::Constant::Map, @map.class
            assert_equal 48, @map.value
          end
        end

        context '.find' do
          setup do
            @group = MIDIMessage::Constant::Group.find(:note)
          end

          should 'return group object' do
            refute_nil @group
            assert_equal MIDIMessage::Constant::Group, @group.class
            assert_equal 'Note', @group.key
            refute_empty @group.constants
            assert @group.constants.all? { |c| c.kind_of?(MIDIMessage::Constant::Map) }
          end
        end
      end

      context 'MessageBuilder' do
        context '#new' do
          context 'note on' do
            setup do
              @group = MIDIMessage::Constant::Group.find(:note)
              @map = @group.find('C3')
              @builder = MIDIMessage::Constant::MessageBuilder.new(MIDIMessage::NoteOn, @map)
            end

            should 'build correct note' do
              @note = @builder.new
              refute_nil @note
              assert_equal 'C3', @note.name
            end
          end

          context 'cc' do
            setup do
              @group = MIDIMessage::Constant::Group.find(:control_change)
              @map = @group.find('Modulation Wheel')
              @builder = MIDIMessage::Constant::MessageBuilder.new(MIDIMessage::ControlChange, @map)
            end

            should 'build correct cc' do
              @cc = @builder.new
              refute_nil @cc
              assert_equal 'Modulation Wheel', @cc.name
            end
          end
        end
      end

      context 'Status' do
        context '.find' do
          should 'find status' do
            assert_equal 0x8, MIDIMessage::Constant::Status.find('Note Off')
            assert_equal 0x9, MIDIMessage::Constant::Status.find('Note On')
            assert_equal 0xB, MIDIMessage::Constant::Status['Control Change']
          end
        end
      end

      context 'Loader' do
        context 'DSL' do
          context '.find' do
            context 'note on' do
              setup do
                @message = MIDIMessage::NoteOn['c3'].new(0, 100)
              end

              should 'create message object' do
                assert_equal(MIDIMessage::NoteOn, @message.class)
                assert_equal('C3', @message.name)
                assert_equal('C', @message.note_name)
                assert_equal('Note On: C3', @message.verbose_name)
                assert_equal([0x90, 0x30, 100], @message.to_a)
              end
            end

            context 'note off' do
              setup do
                @message = MIDIMessage::NoteOff['C2'].new(0, 100)
              end

              should 'create message object' do
                assert_equal(MIDIMessage::NoteOff, @message.class)
                assert_equal('C2', @message.name)
                assert_equal('Note Off: C2', @message.verbose_name)
                assert_equal([0x80, 0x24, 100], @message.to_a)
              end
            end

            context 'cc' do
              setup do
                @message = MIDIMessage::ControlChange.find('Modulation Wheel').new(2, 0x20)
              end

              should 'create message object' do
                assert_equal(MIDIMessage::ControlChange, @message.class)
                assert_equal(@message.channel, 2)
                assert_equal(0x01, @message.index)
                assert_equal(0x20, @message.value)
                assert_equal([0xB2, 0x01, 0x20], @message.to_a)
              end
            end

            context 'system realtime' do
              setup do
                @message = MIDIMessage::SystemRealtime['Stop'].new
              end

              should 'create message object' do
                assert_equal(MIDIMessage::SystemRealtime, @message.class)
                assert_equal('Stop', @message.name)
                assert_equal([0xFC], @message.to_a)
              end
            end

            context 'system common' do
              setup do
                @message = MIDIMessage::SystemCommon['Song Select'].new
              end

              should 'create message object' do
                assert_equal(MIDIMessage::SystemCommon, @message.class)
                assert_equal('Song Select', @message.name)
                assert_equal([0xF3], @message.to_a)
              end
            end
          end
        end
      end
    end
  end
end
