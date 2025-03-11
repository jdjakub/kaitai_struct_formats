meta:
  id: self_2017_uncompressed_snap_32bit
  title: Self 2017 uncompressed snapshot data (32-bit)
  file-extension: tvg
  license: CC0-1.0
  ks-version: 0.9
  endian: le
  bit-endian: be
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
  - id: new_eden_bounds
    type: space_bounds
  - id: new_from_bounds
    type: space_bounds
  - id: new_to_bounds
    type: space_bounds
  - id: new_eden_objects
    size: new_eden_bounds.objs_size
  - id: new_eden_bytes
    size: new_eden_bounds.bytes_size
  - id: new_to_objects
    size: new_to_bounds.objs_size
    doc: TODO to/from other way round if memory regions ordered that way
  - id: new_to_bytes
    size: new_to_bounds.bytes_size
  - id: new_from_objects
    size: new_from_bounds.objs_size
  - id: new_from_bytes
    size: new_from_bounds.bytes_size
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
    doc: TODO factor and repeat somehow...
  - id: old_space_bytes
    size: old_spaces[0].bytes_size
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
      - id: block_activaation_mirror
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
