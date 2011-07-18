#coding=utf-8

require File.expand_path('../test_helper.rb',__FILE__)
require 'message'

describe Message do
    context "消息头结构" do
        it "消息头结构" do
            msg_header = Message::Header.new{ |m|
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
            msg_login = Message::Login.new {|m|
                m.imei = "123456789012345"
            }
            msg_login.data.length.should == 15
            msg_login.data.should == "123456789012345"
        end
        it "客户端登陆-回应" do
            msg_login_rep = Message::LoginRep.new {|m|
                m.desk_id   = 0x1
                m.small     = 0x10
                m.max       = 0x200
                m.client_id = 0x1
            }
            msg_login_rep.data.length.should == 11
            msg_login_rep.data.should == "\0\1\0\0\1\0\0\2\0\0\1"
        end
    end

    context "下发牌消息结构" do
        it "下发牌请求 (服务器->客户端)" do
            msg_push_poke = Message::PushPoke.new { |m|
                m.client_count        =  0x2
                m.you_client_id       =  0x1
                m.show_clinet_id      =  0x1
                m.desktop_money       =  0x20
                m.client1_id          =  0x1
                m.client1_hide_poker  =  0x8
                m.client1_poker_code  =  0x9
                m.client1_post_money  =  0x10
                m.client1_last_money  =  0x190
            }
        end
        it "下发牌回应 (客户端->服务器)" do
            msg_push_poke_rep = Message::PushPokeRep.new {|m|
                m.client_id = 0x1
            }
            msg_push_poke_rep.data.length.should == 1
            msg_push_poke_req.data.should == '\1'
        end
    end

    context "跟注状态消息结构" do
        it "跟注状态上传(客户端->服务器)" do
            msg_push_status = Message::PushStatus.new {|m|
                m.client_id    = 0x1
                m.rep_status   = 0x1
                m.money        = 0x0
            }
            msg_push_status.data.length.should == 6
            msg_push_status.data.should == "\1\1\0\0\0\0"
        end
        it "跟注状态上传回应 (服务器->客户端)" do
            msg_push_status_rep = Message::PushStatusRep.new {|m|
                m.client_id = 0x1
            }
            msg_push_status_rep.data.length.should == 1
            msg_push_status_req.data.should == '\1'
        end
    end


    context "广播跟注消息结构" do
        it "广播跟注状态(服务器->客户端)" do
            msg_broadcast_status = Message::BroadcastStatus.new {|m|
                m.client_id      = 0x1
                m.rep_status     = 0x1
                m.money          = 0x10
                m.can_rep_status = 0x5
            }
            msg_broadcast_status.data.length.should == 7
            msg_broadcast_status.data == '\1\1\0\0\0\10\5'
        end
        it "广播跟注状态回应 (客户端->服务器)" do
            msg_broadcast_status_rep = Message::BroadcastStatusRep.new {|m|
                m.client_id = 0x1
            }
            msg_broadcast_status_rep.data.length.should == 1
            msg_broadcast_status_req.data.should == '\1'
        end
    end

end
