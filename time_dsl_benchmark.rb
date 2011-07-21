module TimeDSL
    def second
      self * 1
    end
    alias_method :seconds, :second

    def minute
      self * 60
    end
    alias_method :minutes, :minute

    def hour
      self * 3600
    end
    alias_method :hours, :hour

    def day
      self * 86400
    end
    alias_method :days, :day

    def week
      self * 604800
    end
    alias_method :weeks, :week

    def month
      self * 2592000
    end
    alias_method :months, :month

    def year
      self * 31471200
    end
    alias_method :years, :year
end
Numeric.send :include, TimeDSL

module BadMetaTimeDSL

    {:second => 1, 
     :minute => 60, 
     :hour => 3600, 
     :day => [24,:hours], 
     :week => [7,:days], 
     :month => [30,:days], 
     :year => [364.25, :days]}.each do |meth, amount|
		define_method "b_#{meth}" do
			amount = amount.is_a?(Array) ? amount[0].send(amount[1]) : amount
			self * amount
		end
		alias_method "b_#{meth}s".intern, "b_#{meth}"
    end
  end
Numeric.send :include, BadMetaTimeDSL

module GoodMetaTimeDSL
  SECOND  = 1
  MINUTE  = SECOND * 60
  HOUR    = MINUTE * 60
  DAY     = HOUR * 24
  WEEK    = DAY * 7
  MONTH   = DAY * 30
  YEAR    = DAY * 364.25

  %w[SECOND MINUTE HOUR DAY WEEK MONTH YEAR].each do |const_name|
      meth = const_name.downcase
      class_eval <<-RUBY
        def g_#{meth}
          self * #{const_name}
        end
        alias g_#{meth}s g_#{meth}
      RUBY
  end
end
Numeric.send :include, GoodMetaTimeDSL

require 'rubygems'
require 'rbench'

TIMES = (ARGV[0] || 100_000).to_i

RBench.run(TIMES) do
	format :width => 65
	column :times
	column :no_meta, :title => 'No Meta'
	column :bad_meta, :title => 'define_method'
	column :good_meta, :title => 'class_eval'
	
	group 'time dsl' do
		report '360.seconds' do
			no_meta {360.seconds}
			bad_meta {360.b_seconds}
			good_meta {360.g_seconds}
		end
		
		report '360.minutes' do
			no_meta {360.minutes}
			bad_meta {360.b_minutes}
			good_meta {360.g_minutes}
		end
		
		report '360.hours' do
			no_meta {360.hours}
			bad_meta {360.b_hours}
			good_meta {360.g_hours}
		end
		
		report '360.days' do
			no_meta {360.days}
			bad_meta {360.b_days}
			good_meta {360.g_days}
		end
		
		report '360.weeks' do
			no_meta {360.weeks}
			bad_meta {360.b_weeks}
			good_meta {360.g_weeks}
		end
		
		report '360.months' do
			no_meta {360.months}
			bad_meta {360.b_months}
			good_meta {360.g_months}
		end
		
		report '360.years' do
			no_meta {360.years}
			bad_meta {360.b_years}
			good_meta {360.g_years}
		end
	end
end
