require 'socket'

p $LOAD_PATH

TCPSocket.open("localhost",54321) do |s|
	s.send "hahahaa",0
	p s.read
end
