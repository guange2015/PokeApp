require 'benchmark'

def sum_upto_inject(nr)
	(1..nr).inject(0) { |sum,n| sum+n }
	end
def sum_upto_each(nr)
	sum = 0
	(1..nr).each { |n| sum += n }
	sum
	end
def sum_upto_map(nr)
	sum = 0
	(1..nr).map {|n| sum+= n }
	sum
end

n = 5000
Benchmark.bm(10) do |x|
	x.report("inject :") { n.times {|nr| sum_upto_inject(nr)} }
	x.report("each   :") { n.times {|nr| sum_upto_each(nr)} }
	x.report("map   :") { n.times {|nr| sum_upto_map(nr)} }
end

