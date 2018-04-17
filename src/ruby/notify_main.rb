require 'logger'
require 'date'
require './notify_get'

#変数定義
CITY_NAME = 'Ishinomaki'
PROC_LINE = '--------------------------------------------------'
array_avg = []
eva_value = []

log = Logger.new("../../Log/system_log/proc_log/JRDelay_#{Date.today}.log")
log.info(PROC_LINE)
log.info('電車遅延通知処理 開始')

if !noti_get(CITY_NAME,array_avg,log) then
  log.error('平均の風速取得処理でエラーが発生したため、処理を終了します')
  log.info(PROC_LINE)
  exit
end

if !eva_insert(CITY_NAME,array_avg,log) then
  log.error('平均値の更新処理でエラーが発生したため、処理を終了します')
  log.info(PROC_LINE)
  exit
end

if !eva_latest(CITY_NAME,eva_value,log) then
  log.error('しきい値の設定処理でエラーが発生したため、処理を終了します')
  log.info(PROC_LINE)
  exit
end

if !eva_decision(log) then
  log.error('通知の判定処理でエラーが発生したため、処理を終了します')
  log.info(PROC_LINE)
  exit
end

log.info('電車遅延通知処理 終了')
log.info(PROC_LINE)
