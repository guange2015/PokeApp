#coding=utf-8

require File.expand_path('../test_helper.rb',__FILE__)
require 'message'

describe Message do
    context "消息头结构" do
        it "消息头结构" do
            msg_header = Message::MessageHeader.new{ |m|
                m.total_length = 0x1
                m.command_id = 0x123
                m.sequence_id = 0x1
                m.status = 0x1
            }
            msg_header.data.length.should == 11
            msg_header.data.should == "\0\0\0\1\1\x23\0\0\0\1\1"           
        end
    end
    
    context "客户端登陆消息结构" do
        it "客户端登陆-请求" do
            pending
        end
        it "客户端登陆-回应" do
            pending
        end
    end

    context "下发牌消息结构" do
        it "下发牌请求 (服务器->客户端)" do
            pending
        end
    end

    context "跟注状态消息结构" do
        it "跟注状态上传(客户端->服务器)" do
            pending
        end
    end


    context "广播跟注消息结构" do
        it "广播跟注状态(服务器->客户端)" do
            pending
        end
    end

end
