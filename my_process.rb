#coding=utf-8
$LOAD_PATH <<  File.expand_path('../',__FILE__)

require 'message'

class MyProcess

	# 接收一个消息体
    # @param [client] 线程socket
    # @param [class_type] 需要返回的类
    # @return 根据class_type将接收的数据实例化为相应的类
	def self.recv(client,class_type)
		content = ''
		while (s = client.recv(class_type.size)).length > 0
			content += s
			break if content.length >= class_type.size
		end
		o = class_type.new
		o << content
		o
	end

	def get_another_client
		#todo
	end

	# Handles a request
    # @param [client] 线程socket
    # @return 没有返回，一直长连接
	def process(client)
		# 1. 处理登陆且确定桌子
		# 2. 下发第一和第二张牌
		@client = client
		msg_login_rep = login

		#这里应该确定双方，才进行发牌
		@desk ||= Message::Desk.new(client,get_another_client)
		@desk.reset #重新取牌 

		push_poke(1)
	end

	def initialize
		@desk = nil
		@client = nil
	end

	def login
		msg_login     = MyProcess.recv(@client,Message::Login)
		msg_login_rep = nil
		if msg_login.header.command_id == Message::Command_ID::WIN_LOGIN \
		&& msg_login.imei.to_cstr.length == 15
			msg_login_rep = Message::LoginRep.new {|m|
				m.header.command_id   = Message::Command_ID::WIN_LOGIN_REP
				m.header.status       = 0
				m.desk_id             = 0x1
				m.small               = 10  #十块钱的底
				m.max                 = 200 #一次梭哈值为200
				m.client_id           = 0x1 #目前对方全为robot,所以client_id全为1
				m.header.total_length = Message::LoginRep.size
			}
		else
			msg_login_rep = Message::Error.new {|m|
				m.header.command_id   = Message::Command_ID::WIN_ERROR
				m.header.status       = Message::ErrorCode::ARGMENTFAIL
				m.header.total_length = Message::LoginRep.size
			}
		end

		@client.send(msg_login_rep.data,0)
	end 
	
	def push_poke(seq)	
		msg_push_poke = Message::PushPoke.new{|m|
			m.header.command_id   = Message::Command_ID::WIN_PUSH_POKE
			m.header.status       = 0
			m.header.total_length = Message::PushPoke.size

			m.client_count  = 2
			m.you_client_id = 1
			m.desktop_money = 20

			if seq == 1
				m.client[0].hide_poker = @desk.poke.client1_codes[seq]
			else
				m.client[0].hide_poker = 0
			end
			m.client[0].poker_code = @desk.poke.client1_codes[seq]
		} 
		@client.send(msg_push_poke.data,0)
	end

	def self.push_status(msg_push_status)
	end

	def self.boradcast_status(msg_boradcast_status)
	end
end

if __FILE__ == $0
	p Message::Desk.new
end