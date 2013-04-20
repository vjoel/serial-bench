require 'msgpack'
require 'yaml'
require 'json'
require 'stringio'

def bench
  times = Process.times
  t0 = times.utime #+ times.stime

  yield

  times = Process.times
  t1 = times.utime #+ times.stime
  t1 - t0
end

def bench_marshal n_iterations, object
  sio = StringIO.new
  t_dump = bench do
    n_iterations.times do
      Marshal.dump(object, sio)
      sio.rewind
    end
  end

  sio.rewind
  if @verbose
    p sio.read; sio.rewind
  end

  object2 = nil
  t_load = bench do
    n_iterations.times do
      object2 = Marshal.load(sio)
      sio.rewind
    end
  end

  #p object2
  puts "not ===" unless object == object2

  [sio.size, t_dump, t_load]
end

def bench_yaml n_iterations, object
  sio = StringIO.new
  t_dump = bench do
    n_iterations.times do
      YAML.dump(object, sio)
      sio.rewind
    end
  end

  sio.rewind
  if @verbose
    puts sio.read; sio.rewind
  end

  object2 = nil
  t_load = bench do
    n_iterations.times do
      object2 = YAML.load(sio)
      sio.rewind
    end
  end

  #p object2
  puts "not ===" unless object == object2

  [sio.size, t_dump, t_load]
end

def bench_json n_iterations, object
  sio = StringIO.new
  t_dump = bench do
    n_iterations.times do
      JSON.dump(object, sio, 100)
      sio.rewind
    end
  end

  sio.rewind
  if @verbose
    puts sio.read; sio.rewind
  end

  object2 = nil
  t_load = bench do
    n_iterations.times do
      object2 = JSON.load(sio)
      sio.rewind
    end
  end

  #p object2
  puts "not ===" unless object == object2

  [sio.size, t_dump, t_load]
end

def bench_msgpack n_iterations, object
  sio = StringIO.new
  pk = MessagePack::Packer.new(sio)
  t_dump = bench do
    n_iterations.times do
      pk.write(object).flush
      sio.rewind
    end
  end

  sio.rewind
  if @verbose
    p sio.read; sio.rewind
  end

  object2 = nil
  upk = MessagePack::Unpacker.new(sio)
  t_load = bench do
    n_iterations.times do
      object2 = upk.read
      sio.rewind
    end
  end

  #p object2
  puts "not ===" unless object == object2

  [sio.size, t_dump, t_load]
end

@verbose = ARGV.delete("-v")


def run_benches(n_objects: 1, n_iterations: 1)
  object = (0...n_objects).map do |i|
    [i, "foo", {"bar" => 1.23}, ["baz", true]]
  end
  #p object

  puts "%-12s: %8d" % ["objects", n_objects]
  puts "%-12s: %8d" % ["iterations", n_iterations]
  puts
  2.times do |i|
    headers =  [["warmup", "bench"][i], "size", "dump", "load"]
    puts "%11s: %8s %8s %8s\n" % headers

    args = [n_iterations, object]
    puts "%11s: %8d %8.4f %8.4f\n" % ["marshal", *bench_marshal(*args)]
    puts "%11s: %8d %8.4f %8.4f\n" % ["yaml", *bench_yaml(*args)]
    puts "%11s: %8d %8.4f %8.4f\n" % ["json", *bench_json(*args)]
    puts "%11s: %8d %8.4f %8.4f\n" % ["msgpack", *bench_msgpack(*args)]
    puts
  end
end

run_benches n_objects: 10000, n_iterations: 1
run_benches n_objects: 1, n_iterations: 10000
