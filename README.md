serial-bench
============

Set of benchmarks for several serialization libraries in ruby.

Currently, this includes:

    marshal
    yaml
    json
    msgppack

The benchmark dumps and loads and checks that the resulting object equals the original. Measurements are size of serialized data in bytes, dump and load times, in seconds.

Results, on a core2-duo 1.7GHz (circa 2009):

N = 10000 objects
     warmup:     size     dump     load
    marshal:   429632   0.0800   0.0500
       yaml:   518894   2.2000   1.1000
       json:   388891   0.1000   0.0800
    msgpack:   279619   0.0100   0.0100

      bench:     size     dump     load
    marshal:   429632   0.1400   0.0800
       yaml:   518894   2.2800   1.2200
       json:   388891   0.0600   0.0900
    msgpack:   279619   0.0000   0.0200

