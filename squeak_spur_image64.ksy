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
  spur_object:
    seq:
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
      class_id:
        value: format_and_class & 0x003FFFFF
  segment:
    seq:
      - id: objects
        type: spur_object
        repeat: expr
        repeat-expr: 10
enums:
  base_version:
    6502: v3_32_no_closures
    6504: v3_32_with_closures
    68000: v3_64_no_closures
    68002: v3_64_with_closures
    68004: spur_64_with_closures
      
