#coding=utf-8

require File.expand_path('../test_helper.rb',__FILE__)
require 'message'

describe Message do
    context "Mesage Header" do
        it "message can service" do
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
    
    context "Message Login" do
        it "message login can service" do
        end
    end
end
