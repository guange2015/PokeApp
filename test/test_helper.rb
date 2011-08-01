$LOAD_PATH << File.expand_path('../../',__FILE__)
$LOAD_PATH << File.expand_path('../../lib',__FILE__)


Dir.foreach( File.expand_path('../../lib',__FILE__) ).each do |file|
   require file if File.extname(file) ==".rb"
end