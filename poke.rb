#coding=utf-8

module Message

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
  class Poke
    PokeCode = {
      1  => :A8,
      2  => :A9,
      3  => :A10,
      4  => :AJ,
      5  => :AQ,
      6  => :AK,
      7  => :AA,
      8  => :B8,
      9  => :B9,
      10 => :B10,
      11 => :BJ,
      12 => :BQ,
      13 => :BK,
      14 => :BA,
      15 => :C8,
      16 => :C9,
      17 => :C10,
      18 => :CJ ,   
      19 => :CQ ,  
      20 => :CK ,  
      21 => :CA ,   
      22 => :D8 ,   
      23 => :D9 ,   
      24 => :D10,    
      25 => :DJ ,  
      26 => :DQ ,   
      27 => :DK ,   
      28 => :DA
    }

    
    def initialize()
      @client1_codes = []    
      @client2_codes = []   
      reset
    end

    def reset
      5.times do |n|
         get_next_code(@client1_codes)
         get_next_code(@client2_codes)
      end
    end

    def get_next_code(l)
      code = rand(28)+1
      return get_next_code(l) if (@client1_codes.include?(code) || @client2_codes.include?(code) )
      l << code
    end

    def get_poke(code)
      PokeCode[code].to_s
    end

    def to_s
      s = 'client1 poke : '
      client1_codes.each do |code|
        s += get_poke(code) +' '
      end
      s += "\nclient2 poke : "
      client2_codes.each do |code|
        s += get_poke(code) +' '
      end
      s
    end

    attr_accessor :client1_codes, :client2_codes
  end

end