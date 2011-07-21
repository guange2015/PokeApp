#coding=utf-8

$LOAD_PATH << File.dirname(File.dirname(__FILE__))
require 'timeout'
require 'my_server'
require 'message'

def get_open_state
  `netstat -an|grep 0.0.0.0:54321`
end

describe MyServer do
  

end
