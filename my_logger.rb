#coding=utf-8

require 'logger'
class MyLogger
	def self.logger
		@@logger ||= create_log
	end

	def self.create_log
		log = Logger.new(STDOUT)
  		#log.level = Logger::WARN
  		log.datetime_format = "%Y-%m-%d %H:%M:%S"

  		log.formatter = proc { |severity, datetime, progname, msg|
		    "#{datetime}: #{msg}\n"
		}
  		log
  	end
end