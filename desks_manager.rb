#coding=utf-8
$LOAD_PATH <<  File.expand_path('../',__FILE__)

require 'message'

# ### 桌子结构 Desk
#
class Desk
  def initialize(*args)
    @poke    = Poke.new
    @sockets = args
    @id      = get_desk_id_seq
  end

  def reset
    @poke.reset
  end
  
  #比最后一张牌大小，用来确定该谁说话
  def win_last(seq)
  	@poke.client1_codes[seq] > @poke.client2_codes[seq]
  end

  def win
  end

  attr_reader :id
  attr_accessor :poke, :sockets
end

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
		@desks.find {|desk| desk.sockets.include? s}
	end

	def <<(arg)
		@desks << arg if Message::Desk === arg
	end
end