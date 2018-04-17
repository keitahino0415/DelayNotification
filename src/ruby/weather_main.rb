require 'logger'
require 'date'
require './weather'
require './weather_log'

#変数定義
weather_array = []
PROC_LINE = '--------------------------------------------------'

log = Logger.new("../../Log/system_log/proc_log/JRDelay_#{Date.today}.log")

log.info(PROC_LINE)
log.info('天気の記録処理 開始')
puts ('処理開始')

#天気取得
if !weather_main("Ishinomaki",weather_array,log)
  log.info('処理を終了します')
  log.info(PROC_LINE)
  puts ('処理の詳細については、下記ファイルを参照してください')
  puts ("../../Log/system_log/proc_log/JRDelay_#{Date.today}.log")
  exit
end

if log(weather_array,log)
  #puts "log書き込み成功！"
else
  #puts "log追加処理でエラーが発生したため、処理を終了します。"
end

log.info('天気の記録処理 正常終了')
log.info(PROC_LINE)
puts ('処理終了')
puts ('処理の詳細については、下記ファイルを参照してください')
puts ("../../Log/system_log/proc_log/JRDelay_#{Date.today}.log")