#coding=utf-8

require File.expand_path('../test_helper.rb',__FILE__)
require 'message'

describe Message do

    def set_header(m)
        m.total_length = 0x1
        m.command_id = 0x123
        m.sequence_id = 0x1
        m.status = 0x1
        m
    end
    before(:all) do  
        @msg_header = Message::Header.new
        set_header(@msg_header)      
        @msg_header_data = "\0\0\0\1\1\x23\0\0\0\1\1" 
        @msg_header_len = Message::Header.size
    end

    context "消息头结构" do
        it "消息头结构" do            
            @msg_header.data.length.should == 11
            @msg_header.data.should == "\0\0\0\1\1\x23\0\0\0\1\1"           
        end
    end
    
    context "客户端登陆消息结构" do
        it "客户端登陆-请求" do
            msg_login = Message::Login.new {|m|
                m.imei = "123456789012345"
            }
            set_header(msg_login.header)
            msg_login.data.length.should == 16 + @msg_header_len
            msg_login.data.should == @msg_header_data+"123456789012345\0"
        end
        it "客户端登陆-回应" do
            msg_login_rep = Message::LoginRep.new {|m|
                m.desk_id   = 0x1
                m.small     = 0x10
                m.max       = 0x200
                m.client_id = 0x1
            }
            set_header(msg_login_rep.header)
            msg_login_rep.data.length.should == @msg_header_len+11
            msg_login_rep.data.should == @msg_header_data+"\x00\x01\x00\x00\x00\x10\x00\x00\x02\x00\x01"
        end
    end

    context "下发牌消息结构" do
        it "下发牌请求 (服务器->客户端)" do
            msg_push_poke = Message::PushPoke.new { |m|
                m.client_count        =  0x2
                m.you_client_id       =  0x1
                m.show_client_id      =  0x1
                m.desktop_money       =  0x20
                m.client[0].id          =  0x1
                m.client[0].hide_poker  =  0x8
                m.client[0].poker_code  =  0x9
                m.client[0].post_money  =  0x10
                m.client[0].last_money  =  0x190
            }
            pending
        end
        it "下发牌回应 (客户端->服务器)" do
            msg_push_poke_rep = Message::PushPokeRep.new {|m|
                m.client_id = 0x1
            }
            set_header(msg_push_poke_rep.header)
            msg_push_poke_rep.data.length.should == @msg_header_len+1
            msg_push_poke_rep.data.should == @msg_header_data+"\1"
        end
    end

    context "跟注状态消息结构" do
        it "跟注状态上传(客户端->服务器)" do
            msg_push_status = Message::PushStatus.new {|m|
                m.client_id    = 0x1
                m.rep_status   = 0x1
                m.money        = 0x0
            }
            set_header(msg_push_status.header)
            msg_push_status.data.length.should == @msg_header_len+6
            msg_push_status.data.should == @msg_header_data+"\1\1\0\0\0\0"
        end
        it "跟注状态上传回应 (服务器->客户端)" do
            msg_push_status_rep = Message::PushStatusRep.new {|m|
                m.client_id = 0x1
            }
            set_header(msg_push_status_rep.header)
            msg_push_status_rep.data.length.should == @msg_header_len+1
            msg_push_status_rep.data.should == @msg_header_data+"\1"
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
            set_header(msg_broadcast_status.header)
            msg_broadcast_status.data.length.should == @msg_header_len+7
            msg_broadcast_status.data == '\1\1\0\0\0\10\5'
        end
        it "广播跟注状态回应 (客户端->服务器)" do
            msg_broadcast_status_rep = Message::BroadcastStatusRep.new {|m|
                m.client_id = 0x1
            }
            set_header(msg_broadcast_status_rep.header)
            msg_broadcast_status_rep.data.length.should == @msg_header_len+1
            msg_broadcast_status_rep.data.should == @msg_header_data+"\1"
        end
    end

end
