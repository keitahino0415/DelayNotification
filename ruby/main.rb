require 'logger'
require 'date'
require './weather'
require './log'

#変数定義
weather_array = []
log = Logger.new("../system_log/JRDelay_#{Date.today}.log")

log.info('処理を開始します')
#天気取得
if weather_main("Ishinomaki",weather_array,log)
  puts weather_array
else
  log.info("処理を終了します")
  exit
end

if log(weather_array,log)
  puts "log書き込み成功！"
else
  puts "log追加処理でエラーが発生したため、処理を終了します。"
end

log.info('処理を終了します')

# weather_array = weather_main("Sendai-shi")
# puts weather_array[1]
# puts log(weather_array)
