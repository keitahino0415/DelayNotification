require 'logger'
require 'date'
require './weather'
require './weather_log'

#変数定義
weather_array = []
PROC_LINE = '--------------------------------------------------'
CITY_NAME = 'Ishinomaki'

log = Logger.new("../../Log/system_log/proc_log/JRDelay_#{Date.today}.log")

log.info(PROC_LINE)
log.info('  MainProc Start')

#天気取得
if !weather_main(CITY_NAME,weather_array,log)
  log.error('  Finish processing')
  log.info(PROC_LINE)
  puts ('For details of processing, please refer to the following file')
  puts ("../../Log/system_log/proc_log/JRDelay_#{Date.today}.log")
  exit
end

if !log_update(weather_array,log)
  log.error('  Finish processing')
  log.info(PROC_LINE)
  puts ('For details of processing, please refer to the following file')
  puts ("../../Log/system_log/proc_log/JRDelay_#{Date.today}.log")
  exit
end

log.info('  MainProc NormalEnd')
log.info(PROC_LINE)
puts ('For details of processing, please refer to the following file')
puts ("../../Log/system_log/proc_log/JRDelay_#{Date.today}.log")
