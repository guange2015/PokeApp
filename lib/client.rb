#coding=utf-8

#  ### 打牌人 
#  真人或Robot
class Client

  def initialize(options={})
    @pokes = []
    options = {:robot => false}.merge(options)
    @robot = options[:robot]
  end

  def deal(poke)
    @pokes << poke
  end

  def robot?
    @robot
  end

  attr_reader :pokes

end