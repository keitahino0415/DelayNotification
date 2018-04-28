require 'logger'
require 'date'
require './notify_get'

#変数定義
CITY_NAME = 'Ishinomaki'
PROC_LINE = '--------------------------------------------------'

log = Logger.new("../../Log/system_log/proc_log/JRDelay_#{Date.today}.log")
log.info(PROC_LINE)
log.info('  Train delay notification processing Start')

if !notification_main(CITY_NAME,log) then
  log.error('  Train delay notification processing AbnormalEnd')
  log.info(PROC_LINE)
  exit
end

log.info('  Train delay notification processing NormalEnd')
log.info(PROC_LINE)
