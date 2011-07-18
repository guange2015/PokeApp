#coding=utf-8

$LOAD_PATH << File.dirname(File.dirname(__FILE__))
require 'timeout'
require 'my_server'

def get_open_state
	`netstat -an|grep 0.0.0.0:54321`
end

describe MyServer do
	before(:all) do
		@t ||= Thread.new{MyServer.new.start}
	end
	
	after(:all) do
		@t.exit if @t
	end
	
    it "当启动时，应该打开54321端口" do    	
    	get_open_state.length.should > 1
    end
    
    it "当启动后，应该可以连接上服务器" do
    	TCPSocket.open("127.0.0.1",54321) {|sock|
    		sock.peeraddr[1].should == 54321
    	}
	end
	
	it "客户端发送一个数据，应该马上回一个数据" do
		TCPSocket.open("localhost",54321) do |s|
			s.send("haha",0).should == 4
    		s.recv(10).should == 'haha'
    	end
	end
end
