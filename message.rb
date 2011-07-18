# coding=utf-8
require 'cstruct'

##
# 消息定义文件
# =====================
# 
# 消息结结构
# --------------------  
#
# 一个完整的消息体包括两个部分
#
# + 消息头 (Message Header)
# + 消息体 (Message Body)
#
# 
# 字段类型定义
# --------
# 
# +  **INT**	   :
#        长度4字节,如0x1为 00000001
# +  **SHORT**	 
#        长度2字节,如0x1为 0001
# +  **BYTE**  :  
#        长度1字节,如0x1为 01
# +  **LONG** :
#        长度8字节,如0x1为 0000000000000001
# +  **STRING** : 
#        不定长,根据具体的描述
#
# 字段定义
# --------
# ### 跟注状态(Rep_Status)
# + *跟注*:  0x1
# + *放弃*:  0x2
# + *全押*:  0x4
# + *加注*:  0x8
# 
# ### 消息类型(Command_ID):
#
#     登陆          WIN_LOGIN             0x1
#     回应登陆      WIN_LOGIN_REP         0x801
#     下发牌请求    WIN_PUSH_POKE         0x2
#     下发牌回复    WIN_PUSH_POKE_REP     0x802
#     上传跟注状态  WIN_PUSH_STATUS       0x3
#     回应跟注状态  WIN_PUSH_STATUS_REP   0x803
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

