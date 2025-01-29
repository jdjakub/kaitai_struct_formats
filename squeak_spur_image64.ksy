meta:
  id: squeak_spur_image64
  title: Squeak Spur 64-Bit Image
  file-extension: tvg
  license: CC0-1.0
  ks-version: 0.9
  endian: le
  bit-endian: be
doc: |
  Squeak Smalltalk Spur VM Image (64-bit)
doc-ref:
  - https://github.com/codefrau/SqueakJS/blob/c22f557c493661af40a44af2c1e89d2ebb265b94/vm.image.js#L89
  - http://wiki.squeak.org/squeak/6290
  - https://clementbera.wordpress.com/2014/01/16/spurs-new-object-format/
seq:
  - id: version_masked
    type: u4
  - id: bytes_in_header
    type: u4
  - id: obj_mem_size
    type: u8
  - id: old_base_addr
    type: u8
  - id: special_objects_oop_int
    type: u8
  - id: last_hash
    type: u8
  - id: saved_window_size
    type: u8
  - id: header_flags
    type: u8
  - id: header_words_12
    type: u8
  - id: header_words_34
    type: u8
  - id: first_seg_size
    type: u8
  
instances:
    version:
      value: version_masked & 0x119ee
      enum: base_version
    use_platform_float_word_order:
      value: version_masked & 1 == 1
    has_closures:
      value: version_masked & 4 == 4
    spur_object_format:
      value: version_masked & 16 == 16
    sista_multiple_bytecode:
      value: version_masked & (1 << 9) >> 9 == 1
    first_segment:
      pos: bytes_in_header
      type: segment

types:
  class_page_bits:
    seq:
      - id: pointers
        type: u8
        repeat: eos
  spur_object:
    seq:
      - id: mark_obj_start
        size: 0
        if: addr_in_seg != -1
      - id: small_format_and_class
        type: u4
      - id: small_size_and_hash
        type: u4
      - id: padding
        type: u8
        if: small_size == 0
      - id: large_format_and_class
        type: u4
        if: small_size == 255
      - id: large_size_and_hash
        type: u4
        if: small_size == 255
      - id: bits
        size: num_words * 8
        type:
          switch-on: class_id
          cases:
            'class_id::class_pages': class_page_bits
    instances:
      small_size:
        value: small_size_and_hash >> 24
      format_and_class:
        value: small_size != 255 ? small_format_and_class : large_format_and_class
      size_and_hash:
        value: small_size != 255 ? small_size_and_hash : large_size_and_hash
      num_words:
        value: small_size != 255 ? small_size : small_format_and_class + (small_size_and_hash & 0x00FFFFFF) * 0x100000000
      hash:
        value: size_and_hash & 0x003FFFFF
      format:
        value: (format_and_class >> 24) & 0x1F
        enum: obj_format
      class_id:
        value: format_and_class & 0x003FFFFF
        enum: class_id
      addr_in_seg:
        value: _io.pos
      address:
        value: _root.old_base_addr + addr_in_seg
      oop:
        value: address + (small_size == 255 ? 8 : 0)
  objects:
    seq:
      - id: object
        type: spur_object
        repeat: eos
  segment:
    seq:
      - id: objects
        type: objects
        size: _root.first_seg_size - 16
      - id: bridge
        size: 16
    instances:
      base_addr:
        value: _parent.old_base_addr
enums:
  base_version:
    6502: v3_32_no_closures
    6504: v3_32_with_closures
    68000: v3_64_no_closures
    68002: v3_64_with_closures
    68004: spur_64_with_closures
  class_id:
    0: unknown
    16: class_pages
  obj_format:
    0: size_zero
    1: fixed_size_with_inst_vars
    2: var_size_no_inst_vars
    3: var_size_with_inst_vars
    4: weak_var_size
    5: weak_fixed_size_with_inst_vars
    9: indexable_64_bit
    10: indexable_32_bit_filled_word
    11: indexable_32_bit_half_word
    12: indexable_16_bit_filled_word
    13: indexable_16_bit_1
    14: indexable_16_bit_2
    15: indexable_16_bit_3
    16: indexable_8_bit_filled_word
    17: indexable_8_bit_1
    18: indexable_8_bit_2
    19: indexable_8_bit_3
    20: indexable_8_bit_4
    21: indexable_8_bit_5
    22: indexable_8_bit_6
    23: indexable_8_bit_7
    24: compiled_method_0
    25: compiled_method_1
    26: compiled_method_2
    27: compiled_method_3
    28: compiled_method_4
    29: compiled_method_5
    30: compiled_method_6
    31: compiled_method_7
    
