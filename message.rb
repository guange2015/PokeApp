# coding=utf-8
require 'cstruct'

##
# RubyGems is the Ruby standard for publishing and managing third party
# libraries.
#
# For user documentation, see:
#
# * <tt>gem help</tt> and <tt>gem help [command]</tt>
# * {RubyGems User Guide}[http://docs.rubygems.org/read/book/1]
# * {Frequently Asked Questions}[http://docs.rubygems.org/read/book/3]
#
# For gem developer documentation see:
#
# * {Creating Gems}[http://docs.rubygems.org/read/chapter/5]
# * Gem::Specification
# * Gem::Version for version dependency notes
#
# Further RubyGems documentation can be found at:
#
# * {RubyGems API}[http://rubygems.rubyforge.org/rdoc] (also available from
#   <tt>gem server</tt>)
# * {RubyGems Bookshelf}[http://rubygem.org]
#
# == RubyGems Plugins
#
# As of RubyGems 1.3.2, RubyGems will load plugins installed in gems or
# $LOAD_PATH.  Plugins must be named 'rubygems_plugin' (.rb, .so, etc) and
# placed at the root of your gem's #require_path.  Plugins are discovered via
# Gem::find_files then loaded.  Take care when implementing a plugin as your
# plugin file may be loaded multiple times if multiple versions of your gem
# are installed.
#
# For an example plugin, see the graph gem which adds a `gem graph` command.
#
# == RubyGems Defaults, Packaging
#
# RubyGems defaults are stored in rubygems/defaults.rb.  If you're packaging
# RubyGems or implementing Ruby you can change RubyGems' defaults.
#
# For RubyGems packagers, provide lib/rubygems/operating_system.rb and
# override any defaults from lib/rubygems/defaults.rb.
#
# For Ruby implementers, provide lib/rubygems/#{RUBY_ENGINE}.rb and override
# any defaults from lib/rubygems/defaults.rb.
#
# If you need RubyGems to perform extra work on install or uninstall, your
# defaults override file can set pre and post install and uninstall hooks.
# See Gem::pre_install, Gem::pre_uninstall, Gem::post_install,
# Gem::post_uninstall.
#
# == Bugs
#
# You can submit bugs to the
# {RubyGems bug tracker}[http://rubyforge.org/tracker/?atid=575&group_id=126]
# on RubyForge
#
# == Credits
#
# RubyGems is currently maintained by Eric Hodel.
#
# RubyGems was originally developed at RubyConf 2003 by:
#
# * Rich Kilmer  -- rich(at)infoether.com
# * Chad Fowler  -- chad(at)chadfowler.com
# * David Black  -- dblack(at)wobblini.net
# * Paul Brannan -- paul(at)atdesk.com
# * Jim Weirch   -- jim(at)weirichhouse.org
#
# Contributors:
#
# * Gavin Sinclair     -- gsinclair(at)soyabean.com.au
# * George Marrows     -- george.marrows(at)ntlworld.com
# * Dick Davies        -- rasputnik(at)hellooperator.net
# * Mauricio Fernandez -- batsman.geo(at)yahoo.com
# * Simon Strandgaard  -- neoneye(at)adslhome.dk
# * Dave Glasser       -- glasser(at)mit.edu
# * Paul Duncan        -- pabs(at)pablotron.org
# * Ville Aine         -- vaine(at)cs.helsinki.fi
# * Eric Hodel         -- drbrain(at)segment7.net
# * Daniel Berger      -- djberg96(at)gmail.com
# * Phil Hagelberg     -- technomancy(at)gmail.com
# * Ryan Davis         -- ryand-ruby(at)zenspider.com
#
# (If your name is missing, PLEASE let us know!)
#
# Thanks!
#
# -The RubyGems Team

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
  # creates an Addrinfo object from the arguments.
  #
  # The arguments are interpreted as similar to self.
  #
  #   Addrinfo.tcp("0.0.0.0", 4649).family_addrinfo("www.ruby-lang.org", 80)
  #   #=> #<Addrinfo: 221.186.184.68:80 TCP (www.ruby-lang.org:80)>
  #
  #   Addrinfo.unix("/tmp/sock").family_addrinfo("/tmp/sock2")
  #   #=> #<Addrinfo: /tmp/sock2 SOCK_STREAM>  
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

