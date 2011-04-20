#!/usr/bin/env ruby

dir = File.dirname(File.expand_path(__FILE__))
$LOAD_PATH.unshift dir + '/../lib'

#
# This example takes all midi input, transposes the notes up one octave and then outputs everything
#
require 'midi-messenger' 

# this example selects the first available input and output devices.  for other
# configurations, see the example "selecting_a_device.rb" to see how devices are 
# selected

#p Device.all.to_s
MIDIMessenger::Device::Output.first.open do |output|

  song = [ 64, 100, 43, 76, 60, 45]
  duration = 0.25

  4.times do
    song.each do |note|
      output.puts(MIDIMessenger::ChannelMessage::Raw.new(0, note, 100))
      sleep(duration)
    end
  end
  
end
