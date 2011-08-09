#coding=utf-8

module Message

# ### 牌定义:
#
#     1 方块8   8  梅花8   15 红桃8   22 黑桃8 
#     2 方块9   9  梅花9   16 红桃9   23 黑桃9 
#     3 方块10  10 梅花10  17 红桃10  24 黑桃10
#     4 方块J   11 梅花J   18 红桃J   25 黑桃J 
#     5 方块Q   12 梅花Q   19 红桃Q   26 黑桃Q 
#     6 方块K   13 梅花K   20 红桃K   27 黑桃K 
#     7 方块A   14 梅花A   21 红桃A   28 黑桃A 
#
  class Poke
    PokeCode = {
      1  => :F8,
      2  => :F9,
      3  => :F10,
      4  => :FJ,
      5  => :FQ,
      6  => :FK,
      7  => :FA,
      8  => :M8,
      9  => :M9,
      10 => :M10,
      11 => :MJ,
      12 => :MQ,
      13 => :MK,
      14 => :MA,
      15 => :R8,
      16 => :R9,
      17 => :R10,
      18 => :RJ ,   
      19 => :RQ ,  
      20 => :RK ,  
      21 => :RA ,   
      22 => :H8 ,   
      23 => :H9 ,   
      24 => :H10,    
      25 => :HJ ,  
      26 => :HQ ,   
      27 => :HK ,   
      28 => :HA
    }

    def initialize()           
      @deals = []
    end

    #重新洗牌
    def shuffle
      @deals.clear
    end

    #发一张牌
    def deal()
      return nil unless @deals.size < PokeCode.size
      code = rand(28)+1
      return deal() if @deals.include? code 
      @deals << code
      code
    end

    #是否为同花顺？
    def self.tonghuashun?(*args)
      tonghua?(*args) and shunzi?(*args)
    end

    #是否为同花？
    def self.tonghua?(*args)
      args.inject(nil) do |last,n|
        return false if last && last != PokeCode[n].to_s[0,1]
        last = PokeCode[n].to_s[0,1]
      end
      true
    end

    #是否为顺子？
    def self.shunzi?(*args)
      args.map{|x| x % 7 == 0 ? 7 : x%7}.sort.inject(nil) do |last,n|
        return false if last && last != n-1
        last = n
      end
      true
    end

    #是否为铁支？
    def self.tiezhi?(*args)
      !(args.group_by do |n| 
        PokeCode[n].to_s[1..-1]
      end.select{|k,v| v.size == 4}.empty? )  
    end

    #是否为葫芦？
    def self.hulu?(*args)
      mutil(:codes => args, :compare_size => 1){ |size|
        size == 3 
      } and \
      mutil(:codes => args, :compare_size => 1){ |size|
        size == 2 
      }
    end

    #是否为三条？
    def self.santiao?(*args)
      mutil(:codes => args, :compare_size => 1){ |size|
        size == 3
      } and \
      mutil(:codes => args, :compare_size => 2){ |size|
        size == 1
      }
    end

    # 是否为两对？
    def self.liangdui?(*args)
      mutil(:codes => args, :compare_size => 2){ |size|
        size == 2
      }
    end

    # 是否是对子?
    def self.duizi?(*args)
      mutil(:codes => args, :compare_size => 1){ |size|
        size == 2
      }
    end

    # 是否为散牌?
    # @todo  这样重复比较有可能性能问题
    def self.sanpai?(*args)
      !(tonghuashun?(*args) || tonghua?(*args) || shunzi?(*args) \
      || tiezhi?(*args) || hulu?(*args) || santiao?(*args) \
      || liangdui?(*args) || duizi?(*args) )
    end

    # 比较个数方法
    # @param [Hash] options 参数
    # @option options [String] :codes 牌集合
    # @option options [int] :compare_size 应该取得的个数
    # @yieldparam [int] :size 比较的判定条件
    # @return [nil] 
    def self.mutil(options={})
      options = {:codes=>[], :compare_size=>0}.merge(options)
      if block_given?
        options[:codes].group_by do |n| 
          PokeCode[n].to_s[1..-1]
        end.select{|k,v| yield v.size}.size == options[:compare_size]
      end
    end

    # 检测是一副什么牌
    # @return [int] 9..1分别为同花顺..散牌
    def self.check(*args)
      return 9 if tonghuashun?(*args)
      return 8 if tiezhi?(*args)
      return 7 if tonghua?(*args)
      return 6 if shunzi?(*args)
      return 5 if hulu?(*args)
      return 4 if santiao?(*args)
      return 3 if liangdui?(*args)
      return 2 if duizi?(*args)
      return 1 if sanpai?(*args)
    end

    # 比一张牌的大小
    # @return [Boolean] code1大于code2返回真
    def self.compare_one(code1, code2)
      n1 = code1 % 7 == 0 ? 7 : code1 % 7
      n2 = code2 % 7 == 0 ? 7 : code2 % 7
            
      if n1 == n2 #如果两牌相等，则比花色
        return code1 > code2
      end
      n1 > n2
    end

    # 获取多个牌的具体值，比如铁支的牌是什么?
    def get_mutil_code(options={})
      options = {:codes=>[], :size=>0}.merge(options)

      options[:codes].group_by do |n| 
          PokeCode[n].to_s[1..-1]
      end.select{|k,v| options[:size] == v.size}.keys
    end

    # 牌比较大小
    # @param [Array] :poke1 玩家1的牌
    # @param [Array] :poke2 玩家2的牌
    # @return [Boolean] poke1大于poke2返回真
    def self.compare(poke1, poke2)
      n1 = check(*poke1) 
      n2 = check(*poke2) 
      if n1 == n2  #同种类型的牌比较，比较复杂
        if n1 == 9 #同花比较最大的
          return poke1.max > poke2.max
        elsif n1 == 8 #铁支，比四个牌的大小
          
        end
      end
      n1 > n2
    end

  end

end