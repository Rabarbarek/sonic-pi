#!/usr/bin/env ruby

## This core file sets up the load path and applies any necessary monkeypatches.

## Ensure all libs in vendor directory are available
Dir["#{File.expand_path("../vendor", __FILE__)}/*/lib/"].each do |vendor_lib|
  $:.unshift vendor_lib
end

#Monkeypatch osc-ruby to add sending skills to Servers
#https://github.com/samaaron/osc-ruby/commit/bfc31a709cbe2e196011e5e1420827bd0fc0e1a8
#and other improvements
require 'osc-ruby'

module OSC

  class Server
    def send(msg, address, port)
      @socket.send msg.encode, 0, address, port
    end
  end

  class OSCDouble64 < OSCArgument
    def tag() 'd' end
    def encode() [@val].pack('G').force_encoding("BINARY") end
  end

  class OSCPacket

    def initialize( string )
      @packet = NetworkPacket.new( string )

      @types = { "i" => lambda{  OSCInt32.new(   get_int32 ) },
        "f" => lambda{  OSCFloat32.new( get_float32 ) },
        "s" => lambda{  OSCString.new(  get_string ) },
        "b" => lambda{  OSCBlob.new(    get_blob )},
        "d" => lambda{  OSCDouble64.new(   get_double64 )}
      }
    end

    def get_arguments
      if @packet.getc == ?,

        tags = get_string
        args = []

        tags.scan(/./) do | tag |
          type_handler = @types[tag]
          raise "Unknown OSC type: #{tag}" unless type_handler
          args << type_handler.call
        end
        args
      end
    end

    def get_double64
      f = @packet.getn(8).unpack('G')[0]
      @packet.skip_padding
      f
    end

  end
end


require 'rubame'

## Teach Rubame::Server#run to block on IO.select
## and therefore not thrash round in a loop
module Rubame
  class Server
    def run(time = 0, &blk)
      readable, writable = IO.select(@reading, @writing)

      if readable
        readable.each do |socket|
          client = @clients[socket]
          if socket == @socket
            client = accept
          else
            msg = read(client)
            client.messaged = msg
          end

          blk.call(client) if client and blk
        end
      end

      # Check for lazy send items
      timer_start = Time.now
      time_passed = 0
      begin
        @clients.each do |s, c|
          c.send_some_lazy(5)
        end
        time_passed = Time.now - timer_start
      end while time_passed < time
    end
  end
end
