meta:
  id: self_2017_uncompressed_snap_32bit
  title: Self 2017 uncompressed snapshot data (32-bit)
  file-extension: tvg
  license: CC0-1.0
  ks-version: 0.9
  endian: le
  bit-endian: le
doc: |
   Self 2017 uncompressed snapshot data (32-bit)
doc-ref:
  - https://github.com/russellallen/self/blob/9daac0fd83931e7a3079af7def23fdc94e251074/vm/src/any/memory/universe.cpp#L574
seq:
  - id: misc_data_delim
    contents: "\n\f\nMisc data\n\f\n!"
  - id: canonical_char
    type: u1
  - id: vm_oops
    type: vm_oops
  - id: tenuring_threshold
    type: u4
  - id: vm_maps
    type: vm_maps
  - id: new_generation_delim
    contents: "\n\f\nNew generation\n\f\n!"
  - id: eden_bounds
    type: space_bounds
  - id: from_space_bounds
    type: space_bounds
  - id: to_space_bounds
    type: space_bounds
  - id: eden_objects
    size: eden_bounds.objs_size
  - id: eden_bytes
    size: eden_bounds.bytes_size
  - id: to_space_objects
    size: to_space_bounds.objs_size
    doc: TODO to/from other way round if memory regions ordered that way
  - id: to_space_bytes
    size: to_space_bounds.bytes_size
  - id: from_space_objects
    size: from_space_bounds.objs_size
    type: from_obj_space
  - id: from_space_bytes
    size: from_space_bounds.bytes_size
  - id: old_generation_delim
    contents: "\n\f\nOld generation\n\f\n!"
  - id: num_old_spaces
    type: u4
  - id: old_spaces
    type: space_bounds
    repeat: expr
    repeat-expr: num_old_spaces
  - id: old_space_objects
    size: old_spaces[0].objs_size
    type: old_obj_space
    doc: TODO factor and repeat somehow...
  - id: old_space_bytes
    size: old_spaces[0].bytes_size
    type: old_bytes_space
  - id: string_table_delim
    contents: "\n\f\nString table\n\f\n!"
  - id: string_table_buckets
    type: strings_bucket
    repeat: expr
    repeat-expr: 20011
    doc: 20011 is a prime number; good hashtable practice
  - id: vm_strings_delim
    contents: "\n\f\nVM strings\n\f\n!"
  - id: vm_strings
    type: u4
    repeat: expr
    repeat-expr: 182
  - id: vtbls_delim
    contents: "\n\f\nvtbls\n\f\n!"
  - id: map_vtbls
    type: map_vtbls
  - id: code_delim
    contents: "\n\f\nCode\n\f\n!"
    doc: TODO code
  - id: processes_delim
    contents: "\n\f\nProcesses\n\f\n!"
    doc: TODO processes
  - id: eof_delim
    contents: "\n\f\nEnd of snapshot\n\f\n!"
    
instances:
  maps_are_canonical:
    value: canonical_char != 0
    
types:
  vm_oops:
    seq:
      - id: lobby
        type: u4
      - id: nil
        type: u4
      - id: true
        type: u4
      - id: false
        type: u4
      - id: string
        type: u4
      - id: assignment
        type: u4
      - id: obj_vector
        type: u4
      - id: byte_vector
        type: u4
      - id: block_traits
        type: u4
      - id: dead_block
        type: u4
      - id: process
        type: u4
      - id: profiler
        type: u4
      - id: outer_activation
        type: u4
      - id: block_activation
        type: u4
      - id: proxy
        type: u4
      - id: fct_proxy
        type: u4
      - id: literals
        type: u4
      - id: slot_annotation
        type: u4
      - id: object_annotation
        type: u4
      - id: error
        type: u4
      - id: assignment_mirror
        type: u4
      - id: block_mirror
        type: u4
      - id: byte_vector_mirror
        type: u4
      - id: outer_method_mirror
        type: u4
      - id: block_method_mirror
        type: u4
      - id: float_mirror
        type: u4
      - id: object_vector_mirror
        type: u4
      - id: slots_mirror
        type: u4
      - id: smi_mirror
        type: u4
      - id: string_mirror
        type: u4
      - id: process_mirror
        type: u4
      - id: outer_activation_mirror
        type: u4
      - id: block_activation_mirror
        type: u4
      - id: proxy_mirror
        type: u4
      - id: fct_proxy_mirror
        type: u4
      - id: profiler_mirror
        type: u4
      - id: mirror_mirror
        type: u4
      - id: id_array
        type: u4
      - id: bug_hunt_names
        type: u4
      - id: compile_with_sic_names
        type: u4
  vm_maps:
    seq:
      - id: oop_smi_map
        type: u4
      - id: oop_float_map
        type: u4
      - id: oop_mark_map
        type: u4
      - id: oop_map_map
        type: u4
  space_bounds:
    doc: |
      Objects grow up from bottom, bytes grow down from top...
      ...and ne'er the twain shall meet!
    seq:
      - id: old_objs_bottom
        type: u4
      - id: old_objs_top
        type: u4
      - id: old_bytes_bottom
        type: u4
      - id: old_bytes_top
        type: u4
    instances:
      top:
        value: old_bytes_top
      bottom:
        value: old_objs_bottom
      size:
        value: top - bottom
      objs_size:
        value: old_objs_top - old_objs_bottom
      bytes_size:
        value: old_bytes_top - old_bytes_bottom
  obj_header:
    seq:
      - id: tag
        type: b2
      - id: hash
        type: b22
      - id: age
        type: b7
      - id: marked
        type: b1
      - id: oop_map
        type: u4
  nmln:
    seq:
      - id: next
        type: u4
      - id: prev
        type: u4
  slot_desc:
    seq:
      - id: name
        type: u4
      - id: tag
        type: b2
      - id: type
        type: b2
        enum: slot_type
      - id: is_vm_slot
        type: b1
      - id: is_parent
        type: b1
      - id: unused_bits
        type: b24
      - id: oop_data
        type: u4
      - id: annotation
        type: u4
  map:
    seq:
      - id: header
        type: obj_header
      - id: vtable
        type: u4
      - id: num_words_in_obj
        type: u4
      - id: num_words_of_slots
        type: u4
      - id: oop_annotation
        type: u4
      - id: add_slot_dependents
        type: nmln
      - id: map_chain
        type: nmln
      - id: dependents
        type: u4
      - id: slots
        type: slot_desc
        repeat: expr
        repeat-expr: num_words_of_slots/4
  lobby:
    seq:
      - id: header
        type: obj_header
  from_obj_space:
    doc: |
      0, 4, 8, c - int / vm
      1, 5, 9, d - oop
      2, 6, a, e - float / vm
      3, 7, b, f - obj mark word
      something is at file offset 0x2216
    instances:
      lobby:
        pos: _root.vm_oops.lobby-1 - _root.from_space_bounds.old_objs_bottom
        type: lobby
      lobby_map:
        type: map
        pos: lobby.header.oop_map-1 - _root.from_space_bounds.old_objs_bottom
      lobby_map2:
        type: obj_header
        pos: lobby_map.header.oop_map-1 - _root.from_space_bounds.old_objs_bottom
  old_obj_space:
    instances:
      lms0:
        type: obj_header
        pos: _root.from_space_objects.lobby_map.slots[0].name-1 - _root.old_spaces[0].old_objs_bottom
  old_bytes_space:
    instances:
      lms0s:
        type: str
        encoding: utf8
        size: 15
        pos: 0x22AB3C
  strings_bucket:
    seq:
      - id: num_strings
        type: u4
      - id: string_oops
        type: u4
        repeat: expr
        repeat-expr: num_strings
  map_vtbls:
    seq:
      - id: slots_map
        type: u4
      - id: slots_map_deps
        type: u4
      - id: smi_map
        type: u4
      - id: float_map
        type: u4
      - id: string_map
        type: u4
      - id: block_map
        type: u4
      - id: outer_method_map
        type: u4
      - id: block_method_map
        type: u4
      - id: byte_vector_map
        type: u4
      - id: obj_vector_map
        type: u4
      - id: map_map
        type: u4
      - id: mark_map
        type: u4
      - id: proxy_map
        type: u4
      - id: fct_proxy_map
        type: u4
      - id: mirror_map
        type: u4
      - id: ovframe_map
        type: u4
      - id: bvframe_map
        type: u4
      - id: process_map
        type: u4
      - id: profiler_map
        type: u4
      - id: assignment_map
        type: u4
enums:
  slot_type:
    0: object
    1: map
    2: argument
