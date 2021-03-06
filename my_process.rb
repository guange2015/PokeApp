#coding=utf-8
$LOAD_PATH <<  File.expand_path('../',__FILE__)

require 'message'

class MyProcess

	ROBOT_ID  = 2
	CLIENT_ID = 1

	# 接收一个消息体
    # @param [client] 线程socket
    # @param [class_type] 需要返回的类
    # @return 根据class_type将接收的数据实例化为相应的类
	def recv(class_type)
		content = ''
		while (s = @client.recv(class_type.size)).length > 0
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

		while poking; end
	end

	def poking
		#这里应该确定双方，才进行发牌
		@desk ||= Message::Desk.new(client,get_another_client)
		@desk.reset #重新取牌 

		seq = 1             ##第几张牌
		doit_p = nil          ##这里要比牌面
		now_fllow_money = 5 ##根注大小

		4.times {
			push_poke(seq)
			
			doit_p = win_last(seq)
			# 两种情况
			# 1. 先由robot出牌,广播打牌消息
			# 2. 先由client出牌,接收client打牌消息
			2.times { 
				if doit_p 
					#robot只跟
					boradcast_status(now_fllow_money)
					doit_p = !doit_p
				else 			
					msg_push_status = push_status
					#client取消跟注
					break if msg_push_status.rep_status & 0x2 					
					doit_p = !doit_p
				end
			}

			seq += 1
		}

		#处理结果
		@desk.win
	end

	def initialize
		@desk = nil
		@client = nil
	end

	def create_error_msg(command_id, status)
		Message::Error.new {|m|
				m.header.command_id   = command_id
				m.header.status       = status
				m.header.total_length = Message::LoginRep.size
			}
	end

	def login
		msg_login     = recv(Message::Login)
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
			msg_login_rep = create_error_msg(Message::Command_ID::WIN_ERROR,
											 Message::ErrorCode::ARGMENTFAIL )
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

		msg_push_poke_rep = recv(Message::PushPokeRep)
		p msg_push_poke_rep.data
	end

	###   接收打牌状态
	def push_status()
		msg_push_status     = recv(Message::PushStatus)
		msg_push_status_rep = Message::PushStatusRep.new {|m|
			m.header.command_id   = Message::Command_ID::WIN_PUSH_STATUS_REP
			m.header.status       = 0
			m.header.total_length = Message::PushPoke.size

			m.client_id  = 1
		}		
		
		@client.send(msg_push_status_rep.data,0)
		msg_push_status 	
	end

    ###   广播打牌状态
	def boradcast_status(now_fllow_money)
		msg_boradcast_status = Message::BroadcastStatus.new {|m|
			m.header.command_id   = Message::Command_ID::WIN_BROADCAST_STATUS
			m.header.status       = 0
			m.header.total_length = Message::PushPoke.size

			m.client_id  = ROBOT_ID
			m.rep_status = 0x2
			m.money = now_fllow_money
		}	
		@client.send(msg_boradcast_status.data,0)

		msg_boradcast_status_rep = recv(Message::BroadcastStatusRep)
		p msg_boradcast_status_rep.data
	end
end

if __FILE__ == $0
	p Message::Desk.new
end