require 'logger'
require 'date'
require './notify_get'

#変数定義
CITY_NAME = 'Ishinomaki'
PROC_LINE = '--------------------------------------------------'

log = Logger.new("../../Log/system_log/proc_log/JRDelay_#{Date.today}.log")
log.info(PROC_LINE)
log.info('電車遅延通知処理 開始')

if !noti_main(CITY_NAME,log) then
  log.error('電車遅延通知処理 異常終了')
  log.info(PROC_LINE)
  exit
end

log.info('電車遅延通知処理 終了')
log.info(PROC_LINE)
