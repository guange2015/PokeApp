#coding=utf-8

$LOAD_PATH << File.dirname(File.dirname(__FILE__))

require 'my_process'
require 'message'

describe MyProcess do
	
  before(:all) do
    @t = Thread.new{MyServer.new.start}
    sleep 2
  end
  
  after(:all) do
    @t.exit if @t
  end

  context "登陆处理" do
    it "成功" do
      TCPSocket.open("127.0.0.1",54321) do |s|
        msg_login = Message::Login.new {|m|
          m.imei = "123456789012345"
          m.header.command_id = Message::Command_ID::WIN_LOGIN
        }

        data = nil

        s.send(msg_login.data,0).should == Message::Login.size
        data = s.recv(Message::LoginRep.size)
        p data.size

        msg_login_rep = Message::LoginRep.new
        msg_login_rep << data
        msg_login_rep.header.command_id.should == Message::Command_ID::WIN_LOGIN_REP
        msg_login_rep.header.status.should == 0
        msg_login_rep.desk_id.should_not   == 0
        msg_login_rep.small.should_not     == 0
        msg_login_rep.max.should_not       == 0
        msg_login_rep.client_id.should_not == 0 

        p "桌号: #{msg_login_rep.desk_id} 金额: #{msg_login_rep.small}-#{msg_login_rep.max}\
             编号: #{msg_login_rep.client_id}"
        
        #开始下发第一张牌
        p Message::PushPoke.size
        data = s.recv(Message::PushPoke.size)
        
        msg_push_poke = Message::PushPoke.new
        msg_push_poke << data
        msg_push_poke.header.command_id.should == Message::Command_ID::WIN_PUSH_POKE

        p "客户端个数: #{msg_push_poke.client_count}\
           客户端ID:   #{msg_push_poke.you_client_id}\
           下一个出牌人: #{msg_push_poke.show_client_id}\
           桌上的钱数: #{msg_push_poke.desktop_money}\
           本机的第一张牌为: #{msg_push_poke.client[msg_push_poke.you_client_id-1].hide_poker}\
           本机的第二张牌为: #{msg_push_poke.client[msg_push_poke.you_client_id-1].poker_code}\
           "

      end     
    end

    it "失败" do
      TCPSocket.open("127.0.0.1",54321) do |s|
        msg_login = Message::Login.new {|m|
          m.imei = "111"
          m.header.command_id = Message::Command_ID::WIN_LOGIN
        }
        data = nil

        s.send(msg_login.data,0).should == Message::Login.size
          data = s.recv(Message::Error.size)

        msg_login_rep = Message::Error.new
        msg_login_rep << data
        msg_login_rep.class.should == Message::Error
        msg_login_rep.header.command_id.should == Message::Command_ID::WIN_ERROR
        msg_login_rep.header.status.should == Message::ErrorCode::ARGMENTFAIL 
      end   
    end
  end

	it "下发一张牌"  do 
		pending
		# msg_push_poke_rep =  MyProcess.push_poke(msg_push_poke)
		# msg_push_poke_rep.class.should == Message::PushPokeRep	
	end

	it "接收玩家跟注状态" do
		pending
		# msg_push_status_rep = MyProcess.push_status(msg_push_status)
		# msg_push_status_rep.class.should == Message::PushStatusRep
	end

	it "广播用户跟注状态" do
		pending
		# msg_boradcast_status_rep = MyProcess.boradcast_status(msg_boradcast_status)
		# msg_boradcast_status_rep.class.should == Message::BroadcastStatusRep
	end



end