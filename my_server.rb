#coding=utf-8

require 'socket'

class MyServer
	def initialize
		@@server ||= TCPServer.new("0.0.0.0",54321)
	end
	
	def start
		loop {
			Thread.new(@@server.accept) do |client|
				s = client.recv(1024)
				client.send(s,0) if s.length > 0
			end 
		}
	end
	
	def MyServer.finalize(id)
		@@server.close if @@server
	end
end

if __FILE__ == $0
	MyServer.new.start
end