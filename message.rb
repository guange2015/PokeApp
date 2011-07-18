# coding=utf-8
require 'cstruct'

##
# 消息定义文件
#
# == 消息结结构
#
# 一个完整的消息体包括两个部分
# * 消息头 (Message Header)
# * 消息体 (Message Body)
#
# == 字段定义
# <table>
# <tr><td>字段名</td>	 <td>长度</td></tr>
# <tr><td>INT</td>	 <td>4字节</td></tr>
# <tr><td>SHORT</td>	 <td>2字节</td></tr>
# <tr><td>BYTE</td>	 <td>1字节</td></tr>
# <tr><td>STRING</td>	 <td>不定长</td></tr>
# <tr><td>LONG</td>	 <td>8字节</td></tr>
# </table>

module Message
class MessageHeader < CStruct
  options :endian => :big
  uint32:total_length
  uint16:command_id
  uint32:sequence_id
  uint8:status
  
  def print
    msg_header.data.bytes do |c|
        print '\x',c.to_s(16)
    end
  end
end

end

