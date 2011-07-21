#coding=utf-8

$LOAD_PATH <<  File.expand_path('../',__FILE__)

require 'message'

# 牌桌管理
#
class DesksManager
	def initialize
		@desks = [] #桌子队列
	end

	# 根据桌子ID查找
	def find_by_id(id)
		@desks.find {|desk| desk.id == id}
	end

	# 根据socket号进行查找
	def find_by_socket(s)
		@desks.find {|desk| desk.socket.include? s}
	end

	def <<(arg)
		@desks << arg if Message::Desk === arg
	end
end