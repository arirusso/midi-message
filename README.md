# MIDI Message

![midi](http://img208.imageshack.us/img208/5623/mks80small.jpg)

Ruby MIDI message objects

## Features

* Flexible API to accommodate various sources and destinations of MIDI data
* Simple approach to System Exclusive data and devices
* [YAML dictionary of MIDI constants](https://github.com/arirusso/midi-message/blob/master/lib/midi.yml)

## Install

`gem install midi-message`

Or if you're using Bundler, add this to your Gemfile

`gem "midi-message"`

## Usage

```ruby
require "midi-message"
```

#### Basic Messages

There are a few ways to create a new MIDI message.  Here are some examples

```ruby
MIDIMessage::NoteOn.new(0, 64, 64)

MIDIMessage::NoteOn["E4"].new(0, 100)

MIDIMessage.with(:channel => 0, :velocity => 100) { note_on("E4") }
```

Those expressions all evaluate to the same object

```ruby
#<MIDIMessage::NoteOn:0x9c1c240
   @channel=0,
   @data=[64, 64],
   @name="E4",
   @note=64,
   @status=[9, 0],
   @velocity=64,
   @verbose_name="Note On: E4">
```

#### SysEx Messages

As with any kind of message, you can begin with raw data

```ruby
MIDIMessage::SystemExclusive.new(0xF0, 0x41, 0x10, 0x42, 0x12, 0x40, 0x00, 0x7F, 0x00, 0x41, 0xF7)
```

Or in a more object oriented way

```ruby  
synth = SystemExclusive::Node.new(0x41, :model_id => 0x42, :device_id => 0x10)

SystemExclusive::Command.new([0x40, 0x7F, 0x00], 0x00, :node => synth)
```

A Node represents a device that you're sending a message to (eg. your Yamaha DX7 is a Node).  Sysex messages can either be a Command or Request

You can use the Node to instantiate a message

```ruby  
synth.command([0x40, 0x7F, 0x00], 0x00)
```

One way or another, you will wind up with a pair of objects like this

```ruby
#<MIDIMessage::SystemExclusive::Command:0x9c1e57c
   @address=[64, 0, 127],
   @checksum=[65],
   @data=[0],
   @node=
    #<MIDIMessage::SystemExclusive::Node:0x9c1e5a4
     @device_id=16,
     @manufacturer_id=65,
     @model_id=66>>
```

#### Parsing

The parse method will take any valid message data and return the object representation

```ruby
MIDIMessage.parse(0x90, 0x40, 0x40)

  #<MIDIMessage::NoteOn:0x9c1c240 ..>

MIDIMessage.parse(0xF0, 0x41, 0x10, 0x42, 0x12, 0x40, 0x00, 0x7F, 0x00, 0x41, 0xF7)

  #<MIDIMessage::SystemExclusive::Command:0x9c1e57c ..>
```

Check out [nibbler](http://github.com/arirusso/nibbler) for more advanced parsing

## Documentation

* [rdoc](http://rubydoc.info/github/arirusso/midi-message)

## Author

* [Ari Russo](http://github.com/arirusso) <ari.russo at gmail.com>

## License

Apache 2.0, See the file LICENSE

Copyright (c) 2011-2015 [Ari Russo](http://arirusso.com)
