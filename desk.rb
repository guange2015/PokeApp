#coding=utf-8

# ### 桌子结构 Desk
#
class Desk

  ## 桌子ID
  @@desktop_id = 1

  def self.get_desk_id_seq
    @@desktop_id += 1
  end

  # 桌子号
  # 客户端
  def initialize(*args)
    @id      = get_desk_id_seq
    @clients = []
  end

  def reset
    @poke.reset
  end
  
  #比最后一张牌大小，用来确定该谁说话
  def win_last(seq)
    @clients[0] > @clients[1]
  end

  def win
  end

  attr_reader :id
  attr_accessor :poke, :sockets
end