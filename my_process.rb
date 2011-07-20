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
	end
	# Handles a request
    # @param [client] 线程socket
    # @return 没有返回，一直长连接
	def self.process(client)
		# 1. 处理登陆且第一次下发牌
		# 2. 
		msg_login = self.recv(client,Message::Login)
		self.login(msg_login)
	end

	def self.login(msg_login)
		if msg_login.header.command_id == Message::Command_ID::WIN_LOGIN \
		   && msg_login.imei.to_cstr.length == 15
			return Message::LoginRep.new {|m|
				m.header.command_id = Message::Command_ID::WIN_LOGIN_REP
				m.header.status = 0
				m.desk_id = 0x1
				m.small = 10  #十块钱的底
				m.max   = 200 #一次梭哈值为200
				m.client_id = 0x1 #目前对方全为robot,所以client_id全为1
				m.header.total_length = Message::LoginRep.size
			}
		end

		return Message::Error.new {|m|
				m.header.command_id = Message::Command_ID::WIN_ERROR
				m.header.status = Message::ErrorCode::ARGMENTFAIL
				m.header.total_length = Message::LoginRep.size
			}
	end 
	
	def self.push_poke(msg_push_poke)	 
	end

	def self.push_status(msg_push_status)
	end

	def self.boradcast_status(msg_boradcast_status)
	end
end