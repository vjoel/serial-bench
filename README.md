serial-bench
============

Set of benchmarks for several serialization libraries in ruby.

Currently, this includes:

* marshal

* yaml

* json

* msgpack

The benchmark dumps and loads (using StringIO and whatever streaming mode the serialization library offers). Then it checks that the resulting object equals the original. Then it measures the size of serialized data in bytes, and the dump and load times, in seconds.

Results, for a core2-duo 1.7GHz (circa 2009), ruby 2.0, unbuntu 12.04, json 1.7.7, msgppack 0.5.4:

* objects     :    10000
* iterations  :        1

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

* objects     :        1
* iterations  :    10000

         warmup:     size     dump     load
        marshal:       50   0.2100   0.3000
           yaml:       53   3.5100   1.9100
           json:       37   0.1900   0.1800
        msgpack:       27   0.0800   0.0400

          bench:     size     dump     load
        marshal:       50   0.2000   0.3100
           yaml:       53   3.5000   1.9200
           json:       37   0.1800   0.1800
        msgpack:       27   0.0800   0.0400
