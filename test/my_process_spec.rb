#coding=utf-8

$LOAD_PATH << File.dirname(File.dirname(__FILE__))

require 'my_process'
require 'message'

describe MyProcess do
	it "登陆处理" do
		msg_login_rep = MyProcess.login(msg_login)
		msg_login_rep.class.should == Message::LoginRep
	end

	it "下发一张牌"  do 
		msg_push_poke_rep =  MyProcess.push_poke(msg_push_poke)
		msg_push_poke_rep.class.should == Message::PushPokeRep	
	end

	it "接收玩家跟注状态" do
		pending
	end

	it "广播用户跟注状态" do
		pending
	end

end