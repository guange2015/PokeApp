#coding=utf-8

require File.expand_path('../test_helper.rb',__FILE__)
require 'desk'


describe Desk do

  before(:all) do
    @desk = Desk.new
  end

  it "桌子号应该唯一"  do
    l = 1.upto(100).inject([]) do |l, n|
      l << Desk.new.id
    end
    l.each do |desk_id|
      l.count(desk_id).should == 1
    end
  end

  it "每个桌子含有两个玩家，1为真实玩家，2为机器人" do
    @desk.clients.size.should == 2
    @desk.clients[0].should_not be_robot
    @desk.clients[1].should be_robot
  end

  it "两人拿的牌不能有相同的牌" do
    @desk.deal
    l = @desk.clients[0].pokes + @desk.clients[1].pokes
    l.size.should == 5*2
    l.each do |desk_id|
      l.count(desk_id).should == 1
    end
  end

end