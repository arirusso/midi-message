#!/usr/bin/env ruby
#
# (c)2011 Ari Russo and licensed under the Apache 2.0 License
# 

# better way to do this?
@@data = %q{

Control Change:
  Bank Select: 0
  Modulation Wheel: 1
  Breath Controller: 2
  Foot Controller: 4
  Portamento Time: 5
  Data Entry MSB: 6
  Channel Volume: 7
  Balance: 8
  Pan: 10
  Expression Controller: 11
  General Purpose Controllers: 16
  General Purpose Controllers: 17
  General Purpose Controllers: 18
  General Purpose Controllers: 19
  LSB for controller 0: 32
  LSB for controller 1: 33
  LSB for controller 2: 34
  LSB for controller 3: 35
  LSB for controller 4: 36
  LSB for controller 5: 37
  LSB for controller 6: 38
  LSB for controller 7: 39
  LSB for controller 8: 40
  LSB for controller 9: 41
  LSB for controller 10: 42
  LSB for controller 11: 43
  LSB for controller 12: 44
  LSB for controller 13: 45
  LSB for controller 14: 46
  LSB for controller 15: 47
  LSB for controller 16: 48
  LSB for controller 17: 49
  LSB for controller 18: 50
  LSB for controller 19: 51
  LSB for controller 20: 52
  LSB for controller 21: 53
  LSB for controller 22: 54
  LSB for controller 23: 55
  LSB for controller 24: 56
  LSB for controller 25: 57
  LSB for controller 26: 58
  LSB for controller 27: 59
  LSB for controller 28: 60
  LSB for controller 29: 61
  LSB for controller 30: 62
  LSB for controller 31: 63
  Hold Pedal: 64
  Portamento: 65

Control Mode:
  All Sound Off: 120
  All Controllers Off: 121
  Local Keyboard Toggle: 122
  All Notes Off: 123
  Omni Mode Off: 124
  Omni Mode On: 125
  Mono: 126
  Poly: 127

System Realtime:
  Start: 0xFA
  Clock: 0xF8
  Continue: 0xFB
  Stop: 0xFC
  Reset: 0xFF
  ActiveSense: 0xFE

Manufacturers:

  SequentialCircuits: 1
  BigBriar: 2
  Octave: 3
  Moog: 4
  Passport: 5
  Lexicon: 6

  PAIA: 0x11
  Simmons: 0x12
  GentleElectric: 0x13
  Fairlight: 0x14
  BonTempi: 0x20
  SIEL: 0x21
  SyntheAxe: 0x23

  Kawai: 0x40
  Roland: 0x41
  Korg: 0x42
  Yamaha: 0x43
  Casio: 0x44
  Akai: 0x47

  Emagic: [0x00, 0x20, 0x31]
  Behringer: [0x00, 0x20, 0x32]

Note:

  C4:  60
  C#4: 61
  D4:  62
  D#4: 63
  E4:  64

}