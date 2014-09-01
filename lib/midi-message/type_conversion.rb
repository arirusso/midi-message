module MIDIMessage
 
  # Helper for converting nibbles and bytes
  module TypeConversion
    
    extend self

    # Convert an array of hex nibbles to an array of numeric bytes
    # eg ["9", "0", "4", "0"] to [0x90, 0x40]
    #
    # @param [Array<String>] An array of hex nibbles eg ["9", "0", "4", "0"]
    # @return [Array<Fixnum] An array of numeric bytes eg [0x90, 0x40]
    def hex_chars_to_numeric_byte_array(nibbles)
      nibbles = nibbles.dup # Don't mess with the input
      # get rid of last nibble if there's an odd number
      # it will be processed later anyway
      nibbles.slice!(nibbles.length-2, 1) if nibbles.length.odd?
      bytes = []
      while !(nibs = nibbles.slice!(0,2)).empty?
        byte = (nibs[0].hex << 4) + nibs[1].hex
        bytes << byte
      end
      bytes
    end
    
    # Convert byte string to an array of numeric bytes
    # eg. "904040" to [0x90, 0x40, 0x40]
    # @param [String] string A string representing hex digits eg "904040"
    # @return [Array<Fixnum>] An array of numeric bytes eg [0x90, 0x40, 0x40]
    def hex_string_to_numeric_byte_array(string)
      string = string.dup
      bytes = []
      until string.eql?("")
        bytes << string.slice!(0, 2).hex
      end
      bytes
    end
    
    # Convert a string of hex digits to an array of nibbles
    # eg. "904040" to ["9", "0", "4", "0", "4", "0"]
    # @param [String] string A string representing hex digits eg "904040"
    # @return [Array<String>] An array of hex nibble chars eg ["9", "0", "4", "0", "4", "0"]
    def hex_str_to_hex_chars(string)
      string.split(//)    
    end
    
    # Convert an array of numeric bytes to a string of hex digits
    # eg. [0x90, 0x40, 0x40] to "904040"
    # @param [Array<Fixnum>] bytes An array of numeric bytes eg [0x90, 0x40, 0x40]
    # @return [String] A string representing hex digits eg "904040"
    def numeric_byte_array_to_hex_string(bytes)
      string_bytes = bytes.map do |byte| 
        string = byte.to_s(16)
        string = "0#{string}" if string.length.eql?(1)
        string
      end
      string_bytes.join.upcase
    end
    
    # Convert a numeric byte to hex chars
    # eg 0x90 to ["9", "0"]
    # @param [Fixnum] num A numeric byte eg 0x90
    # @return [Array<String>] An array of hex nibble chars eg ["9", "0"]
    def numeric_byte_to_hex_chars(num)
      nibbles = numeric_byte_to_nibbles(num)
      nibbles.map { |n| n.to_s(16) }      
    end

    # Convert a numeric byte to nibbles
    # eg 0x90 to [0x9, 0x0]
    # @param [Fixnum] num A numeric byte eg 0x90
    # @return [Array<Fixnum>] An array of nibbles eg [0x9, 0x0]
    def numeric_byte_to_nibbles(num)
      [((num & 0xF0) >> 4), (num & 0x0F)]
    end

  end
  
end
