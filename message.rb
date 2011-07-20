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
# ### 消息头
#
#     字段名        中文名     类型  备注
#     Total_Length  包长度     INT 
#     Command_ID    消息类型   SHORT 
#     Sequence_ID   消息流水   INT   交互所产生的序号,连接不断就不变
#     STATUS        状态       BYTE  状态
# 
# 字段定义
# --------
# ### 跟注状态(Rep_Status)
# 
#     跟注:  0x1
#     放弃:  0x2
#     全押:  0x4
#     加注:  0x8
# 
# {include:Message::Command_ID}
# ### 牌定义:
#
#     1 黑桃8   8   红桃8   15  梅花8   22  方块8
#     2 黑桃9   9   红桃9   16  梅花9   23  方块9
#     3 黑桃10  10  红桃10  17  梅花10  24  方块10
#     4 黑桃J   11  红桃J   18  梅花J   25  方块J
#     5 黑桃Q   12  红桃Q   19  梅花Q   26  方块Q
#     6 黑桃K   13  红桃K   20  梅花K   27  方块K
#     7 黑桃A   14  红桃A   21  梅花A   28  方块A
#
# {include:Message:ErrorCode}
#
#
# 消息交互
# --------
#
# {include:Message::Error} 
# 
# {include:Message::Login} 
# 
# {include:Message::LoginRep}
# 
# {include:Message::PushPoke}
#
# {include:Message::PushPokeRep}
#
# {include:Message::PushStatus}
#
# {include:Message::PushStatusRep}
#
# {include:Message::BroadcastStatus}
#
# {include:Message::BroadcastStatusRep}
#
module Message

# ### 消息类型(Command_ID):
#
#     消息              字段名                    值 
#     登陆              WIN_LOGIN                 0x1
#     回应登陆          WIN_LOGIN_REP             0x801
#     下发牌请求        WIN_PUSH_POKE             0x2
#     下发牌回复        WIN_PUSH_POKE_REP         0x802
#     上传跟注状态      WIN_PUSH_STATUS           0x3
#     回应跟注状态      WIN_PUSH_STATUS_REP       0x803
#     广播跟注状态      WIN_BROADCAST_STATUS      0x4
#     回应广播跟注状态  WIN_BROADCAST_STATUS_REP  0x804
#     统一出错处理      WIN_ERROR                 0x9
#
  class Command_ID
    WIN_LOGIN                 = 0x1
    WIN_LOGIN_REP             = 0x801
    WIN_PUSH_POKE             = 0x2
    WIN_PUSH_POKE_REP         = 0x802
    WIN_PUSH_STATUS           = 0x3
    WIN_PUSH_STATUS_REP       = 0x803
    WIN_BROADCAST_STATUS      = 0x4
    WIN_BROADCAST_STATUS_REP  = 0x804
    WIN_ERROR                 = 0x9
  end

# ### 状态 STATUS
# 
#     成功    :  0
#     认证错误:  1
#     其他错误:  9
#     桌子已满:  2
#     参数错误:  3
#
  class ErrorCode
    SUCCESS     = 0x0
    AUTHFAIL    = 0x1
    UNKNOWN     = 0x9
    DESKFULL    = 0x2
    ARGMENTFAIL = 0x3
  end

# ### 消息头
#
#     字段名        中文名     类型  备注
#     Total_Length  包长度     INT 
#     Command_ID    消息类型   SHORT 
#     Sequence_ID   消息流水   INT   交互所产生的序号,连接不断就不变
#     STATUS        状态       BYTE  状态
  class Header < CStruct
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

# ### 统一出错消息包
#
#     只包含消息头
  class Error < CStruct
    options :endian => :big
    Header :header
  end

# @author Full Name
# ### 客户端登陆-请求
# 
#     字段名 类型    长度  备注
#     IMEI   STRING  16    最后以0结尾
  class Login < CStruct
    options :endian => :big
    Header :header
    uchar :imei, [16] #本来应该定15位的,但末尾有一位为0
  end

# ### 客户端登陆-回应
# 
#     字段名    类型   长度      备注
#     Desk_ID   SHORT  桌子号
#     SMALL     INT    最小金额
#     MAX       INT    最大金额
#     Client_ID BYTE             客户端序号, 2人的话，就是1和2
  class LoginRep < CStruct
    options :endian => :big
    Header :header
    uint16 :desk_id 
    uint32 :small
    uint32 :max
    uchar  :client_id
  end

# ### 下发牌请求 (服务器->客户端)
# 
#     字段名              类型  长度   备注
#     Client_Count        BYTE         客户端个数,一般为2
#     YOU_CLIENT_ID       BYTE         你的CLIENT_ID
#     SHOW_CLINET_ID      BYTE         本次该谁出牌
#     DESKTOP_MONEY       INT          桌子上押的金额
#     Client1_ID          BYTE         客户端1的ID
#     Client1_HIDE_POKER  BYTE         参见牌定义，第一次下且对应client_id才有值
#     Client1_POKER_CODE  BYTE         参见牌定义
#     Client1_POST_MONEY  INT          已押注
#     Client1_LAST_MONEY  INT          本次剩余金额
#     此处是重复Client1,有几次重复应该根据Client_Count来判断
  class PushPoke < CStruct
    options :endian => :big
    Header :header
    uchar:client_count
    uchar:you_client_id     
    uchar:show_clinet_id    
    uint32:desktop_money   
    
    class PushPokeClient <CStruct
      options :endian => :big
      uchar :id        
      uchar :hide_poker
      uchar :poker_code
      uint32:post_money
      uint32:last_money
    end  

    PushPokeClient :client, [2]
  end
# ### 下发牌回应(客户端->服务器)
# 
#     字段名              类型  长度  备注
#     Client_ID           BYTE    
  class PushPokeRep < CStruct
    options :endian => :big
    Header :header
    uchar  :client_id
  end

# ### 跟注状态上传(客户端->服务器)
# 
#     字段名      类型  长度  备注
#     Client_ID   BYTE    
#     Rep_Status  BYTE        跟注状态
#     Money       INT         跟多少金额，主要是为了获取加注数
  class PushStatus < CStruct
    options :endian => :big
    Header :header
    uchar:client_id 
    uchar:rep_status
    uint32:money     
  end

## ### 跟注状态回应(服务器->客户端)
# 
#     字段名      类型  长度  备注
#     Client_ID   BYTE    
  class PushStatusRep < CStruct
    options :endian => :big
    Header :header
    uchar  :client_id
  end

## ### 广播跟注状态(服务器->客户端)
# 
#     字段名           类型  长度   备注
#     Client_ID        BYTE    
#     Rep_Status       BYTE         跟注状态
#     Money            INT          跟多少金额，主要是为了获取加注数
#     CAN_Rep_Status   BYTE         当前能够使用的状态
  class BroadcastStatus < CStruct
    options :endian => :big
    Header :header
    uchar:client_id     
    uchar:rep_status    
    uint32:money         
    uchar:can_rep_status
  end

## ### 回应广播跟注状态(客户端->服务器)
# 
#     字段名           类型  长度  备注
#     Client_ID        BYTE        回复你的ID
  class BroadcastStatusRep < CStruct
    options :endian => :big
    Header :header
    uchar  :client_id
  end
end

