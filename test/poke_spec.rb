#coding=utf-8

require File.expand_path('../test_helper.rb',__FILE__)

# 同花顺：拥有五张连续性花色的顺子。如果顺子一样大，则比最大张牌的花色。 
# 铁支：四张相同数字的牌，外加一单张，比铁支大小，[A]铁支最大。 
# 葫芦：由[三条]加一个[一对]所组成的牌，比三条大小。 
# 同花：不构成顺子的五张同花色的牌，先比最大的单张，相同再比次大的单张，以此类推，如果五张牌大小均相同，则比最大张牌的花色。 
# 顺子：五张连续数字的牌组，但花色不相同。如果顺子一样大，则比最大张牌的花色。 
# 三条：牌型由三张相同的牌加任两张，比三条的大小。 
# 两对：牌型中五张牌由两组两张同等级的牌所组成。先比两组对子的大小，如果对子大小均相同，再比剩余的单张，如果还是一样，则比大对子的最大花色。 
# 散牌：单一型态的五张散牌所组成，不成对（二对），不成三条，不成顺（同花顺），不成同花，不成葫芦，不成铁支，先比最大的单张，相同再比次大的单张，以此类推，如果五张牌大小均相同，则比最大张牌的花色
# 牌型比较规则
# 牌型比较：同花顺＞铁支＞葫芦＞同花＞顺子＞三条＞二对＞对子＞散牌 
# 数字比较：Ａ＞Ｋ＞Ｑ＞Ｊ＞１０＞９＞８ 
# 花色比较：黑桃＞红心＞梅花＞方块


describe Message::Poke do

  before(:all) do
    @poke = Message::Poke.new
  end

  def check(*options)
    @poke.check(options)
  end

  it "同花顺" do
    Message::Poke.should be_tonghuashun(10,11,12,13,14)
  end

  it "铁支" do
    Message::Poke.should be_tiezhi(1,8,15,22,3)
  end

  it "葫芦" do
    Message::Poke.should be_hulu(1,8,15,5,12) 
  end

  it "同花" do
    Message::Poke.should_not be_tonghuashun(1,3,4,5,7)
    Message::Poke.should be_tonghua(1,3,4,5,7)
  end

  it "顺子" do
    Message::Poke.should be_shunzi(1,16,17,25,5)
    Message::Poke.should_not be_tonghuashun(1,16,17,25,5)
  end

  it '三条' do
    Message::Poke.should be_santiao(1,8,15,2,3)
    Message::Poke.should_not be_hulu(1,8,15,2,3)
  end

  it '两对' do
    Message::Poke.should be_liangdui(1,8,9,2,3)
  end

  it '对子' do
    Message::Poke.should be_duizi(27,28,15,2,9)
    Message::Poke.should_not be_liangdui(27,28,15,2,9)
    Message::Poke.should_not be_santiao(27,28,15,2,9)
  end

  it '散牌' do
    Message::Poke.should be_sanpai(27,28,15,16,3)
  end

  it '牌型不同比较' do
    Message::Poke.compare([10,11,12,13,14],[1,3,4,5,7]).should be_true
    Message::Poke.compare([27,28,15,2,9],[27,28,15,2,8]).should be_true
  end


  it '比一张牌' do
    Message::Poke.compare_one(7,14).should be_false
    Message::Poke.compare_one(7,26).should be_true
  end
  
end