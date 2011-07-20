#coding=utf-8

$LOAD_PATH << File.dirname(File.dirname(__FILE__))

require 'my_process'
require 'message'

describe MyProcess do
	context "登陆处理" do
		it "成功" do
			msg_login = Message::Login.new {|m|
				m.imei = "123456789012345"
				m.header.command_id = Message::Command_ID::WIN_LOGIN
			}
			msg_login_rep = MyProcess.login(msg_login)
			msg_login_rep.header.command_id.should == Message::Command_ID::WIN_LOGIN_REP
			msg_login_rep.header.status.should == 0
			msg_login_rep.desk_id.should_not == 0
			msg_login_rep.small.should_not == 0
			msg_login_rep.max.should_not == 0
			msg_login_rep.client_id.should_not == 0		
		end

		it "失败" do
			msg_login = Message::Login.new {|m|
				m.imei = "111"
				m.header.command_id = Message::Command_ID::WIN_LOGIN
			}
			msg_login_rep = MyProcess.login(msg_login)
			msg_login_rep.class.should == Message::Error
			msg_login_rep.header.command_id.should == Message::Command_ID::WIN_ERROR
			msg_login_rep.header.status.should == Message::ErrorCode::ARGMENTFAIL		
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