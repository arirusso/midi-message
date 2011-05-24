#!/usr/bin/env ruby
#

require 'yaml'
require 'singleton'

module MIDIMessage

  # MIDI Constants
  class Constant

    include Singleton

    def initialize
      # cache the constants data
      require 'midi-message/constants'
      @dict = YAML::load(@@data)
    end

    def [](key)
      @dict[key] #or @dict.find { |k,v| key.downcase.eql?(k.downcase) }.last
    end

    def self.[](key)
      instance[key]
    end

  end

end
