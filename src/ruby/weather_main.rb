require 'logger'
require 'date'
require './weather'
require './weather_log'

#変数定義
weather_array = []
PROC_LINE = '--------------------------------------------------'

log = Logger.new("../../Log/system_log/proc_log/JRDelay_#{Date.today}.log")

log.info(PROC_LINE)
log.info('  Recording processing of weather information Start')

#天気取得
if !weather_main("Ishinomaki",weather_array,log)
  log.info('  Finish processing')
  log.info(PROC_LINE)
  puts ('For details of processing, please refer to the following file')
  puts ("../../Log/system_log/proc_log/JRDelay_#{Date.today}.log")
  exit
end

if !log_update(weather_array,log)
  log.info('  Finish processing')
  log.info(PROC_LINE)
  puts ('For details of processing, please refer to the following file')
  puts ("../../Log/system_log/proc_log/JRDelay_#{Date.today}.log")
  exit
end

log.info('  Recording processing of weather information NormalEnd')
log.info(PROC_LINE)
puts ('For details of processing, please refer to the following file')
puts ("../../Log/system_log/proc_log/JRDelay_#{Date.today}.log")
