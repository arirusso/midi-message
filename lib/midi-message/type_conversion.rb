module MIDIMessage
 
  # Helper for converting nibbles and bytes
  module TypeConversion
    
    extend self

    def hex_chars_to_numeric_byte_array(nibbles)
      nibbles = nibbles.dup
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
    
    # Convert byte str to byte array 
    def hex_string_to_numeric_byte_array(str)
      str = str.dup
      bytes = []
      until str.eql?("")
        bytes << str.slice!(0, 2).hex
      end
      bytes
    end
    
    # Converts a string of hex digits to bytes
    def hex_str_to_hex_chars(str)
      str.split(//)    
    end
    
    def numeric_byte_array_to_hex_string(bytes)
      bytes.map { |b| s = b.to_s(16); s.length.eql?(1) ? "0#{s}" : s }.join.upcase
    end
    
    def numeric_byte_to_hex_chars(num)
      [((num & 0xF0) >> 4), (num & 0x0F)].map { |n| n.to_s(16) }      
    end

    
  end
  
end
