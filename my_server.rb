#coding=utf-8

require 'socket'

$LOAD_PATH <<  File.expand_path('../',__FILE__)
require 'my_logger'

class MyServer
	def initialize
		@@server ||= TCPServer.new("0.0.0.0",54321)
		@logger = MyLogger.logger
		@logger.debug 'server start'
	end
	
	def start		
		while (session = @@server.accept)
			Thread.new(session) do |client|
				@logger.debug client.addr
				s = client.recv(1024)
				client.send(s,0) if s.length > 0
			end
			@logger.debug 'server listen' 
		end		
	end
	
	def MyServer.finalize(id)
		close
		@logger.debug 'server closed'
	end

	def self.close
		@@server.close if @@server
	end
end

if __FILE__ == $0
	MyServer.new.start
end