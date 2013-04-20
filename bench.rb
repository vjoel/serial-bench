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

def bench_marshal object
  sio = StringIO.new
  t_dump = bench do    
    Marshal.dump(object, sio)
  end

  sio.rewind
  if @verbose
    p sio.read; sio.rewind
  end

  object2 = nil
  t_load = bench do    
    object2 = Marshal.load(sio)
  end

  #p object2
  puts "not ===" unless object == object2
  
  [sio.size, t_dump, t_load]
end

def bench_yaml object
  sio = StringIO.new
  t_dump = bench do    
    YAML.dump(object, sio)
  end

  sio.rewind
  if @verbose
    puts sio.read; sio.rewind
  end

  object2 = nil
  t_load = bench do    
    object2 = YAML.load(sio)
  end

  #p object2
  puts "not ===" unless object == object2
  
  [sio.size, t_dump, t_load]
end

def bench_json object
  sio = StringIO.new
  t_dump = bench do    
    JSON.dump(object, sio, 100)
  end

  sio.rewind
  if @verbose
    puts sio.read; sio.rewind
  end

  object2 = nil
  t_load = bench do    
    object2 = JSON.load(sio)
  end

  #p object2
  puts "not ===" unless object == object2
  
  [sio.size, t_dump, t_load]
end

def bench_msgpack object
  sio = StringIO.new
  pk = MessagePack::Packer.new(sio)
  t_dump = bench do
    pk.write(object).flush
  end

  sio.rewind
  if @verbose
    p sio.read; sio.rewind
  end

  object2 = nil
  upk = MessagePack::Unpacker.new(sio)
  t_load = bench do    
    object2 = upk.read
  end

  #p object2
  puts "not ===" unless object == object2
  
  [sio.size, t_dump, t_load]
end

N = 10000
@verbose = ARGV.delete("-v")

object = (0...N).map do |i|
  [i, "foo", {"bar" => 1.23}, ["baz", true]]
end
#p object

puts "N = #{N} objects"
2.times do |i|
  puts "%10s: %8s %8s %8s\n" % [["warmup", "bench"][i], "size", "dump", "load"]
  puts "%10s: %8d %8.4f %8.4f\n" % ["marshal", *bench_marshal(object)]
  puts "%10s: %8d %8.4f %8.4f\n" % ["yaml", *bench_yaml(object)]
  puts "%10s: %8d %8.4f %8.4f\n" % ["json", *bench_json(object)]
  puts "%10s: %8d %8.4f %8.4f\n" % ["msgpack", *bench_msgpack(object)]
  puts
end
