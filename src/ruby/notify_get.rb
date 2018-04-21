require 'net/http'
require 'net/https'
require 'uri'
require 'json'
require 'OpenSSL'
require 'sqlite3'
require 'date'

def noti_get(city_name,array_avg,log)
  begin
    log.info(" 平均の風速取得処理　開始")
    db = SQLite3::Database.open "../../DB/weather_db/#{city_name}.db"
    array_avg.push(db.execute "SELECT ROUND(AVG(wind_speed),2) FROM Log;")
    log.info(" 平均の風速取得処理　正常終了")
    return true
  rescue
    log.error(" 平均の風速取得処理 異常終了")
    return false
  ensure
    db.close
  end
end

def eva_insert(city_name,array_avg,log)
  begin
    log.info(' 平均値更新処理 開始')
    db = SQLite3::Database.open "../../DB/weather_db/#{city_name}.db"
    db.execute "INSERT INTO evaluation (Wind_Avg) VALUES(#{array_avg[0][0][0]});"
    proc_line = db.execute "SELECT changes();"

    if proc_line == 0
      return false
    end
    log.info(' 平均値更新処理 正常終了')
    return true
  rescue
    log.error(" 平均値更新処理 異常終了")
    return false
  ensure
    db.close
  end
end

def eva_latest(city_name,eva_value,log)
  begin
    log.info(' しきい値取得処理 開始')
    db = SQLite3::Database.open "../../DB/weather_db/#{city_name}.db"
    eva_value = db.execute "SELECT MAX(id),wind_avg FROM evaluation;"
    if eva_value[0][1].nil?
      return false
    end
    log.info(" しきい値取得処理 正常終了")
    return true
  rescue
    log.error(" しきい値取得処理 異常終了")
    return false
  ensure
    db.close
  end
end

#次回ここから(しきい値と3,6,9時間後の風力を比較して、通知するか判定)
def eva_decision(city_name,array_avg,delay_date,log)

  #変数定義
  result = []
  weather_hash = {}
  count = 0

  begin
    log.info(' 通知判定処理 開始')
    if !weather_prediction(city_name,result) then
      return false
    end
    result[0]['list'][0].each do |list|
      weather_hash[result[0]['list'][count]['dt_txt']] = result[0]['list'][count]['wind']['speed']
      count = count + 1
    end
    weather_hash.each do |key,value|
      if array_avg[0][0][0] <= value then
        delay_date.push(key.gsub(" ","@"))
      end
    end

    log.info(' 通知判定処理 正常終了')
    return true
  rescue
    log.error(" 通知判定処理 異常終了")
    return false
  end
end

def weather_prediction(city_name,result)
  begin
    api_key = 'a8fe10ee1619eadb53849afee0eb18cc'
    uri = URI.parse("http://api.openweathermap.org/data/2.5/forecast?q=#{city_name},jp&units=metric&APPID=#{api_key}")
    json = Net::HTTP.get(uri)
    result.push(JSON.parse(json))
    code = result[0]["cnt"]
    if code != 0
      return true
    else
      return false
    end
  rescue
    return false
  end
end

def delay_noti(delay_date)
    buf = []

    system("bash ../shell/noti.sh 本日、下記の時間帯にJRが遅延する恐れがあります。")
    delay_date.each do |msg|
      system("bash ../shell/noti.sh #{msg}")
    end
end

def noti_main(city_name,log)

  begin
    #変数定義
    array_avg = []
    eva_value = []
    delay_date = []

    if !noti_get(city_name,array_avg,log) then
      log.error('平均の風速取得処理でエラーが発生したため、処理を終了します')
      return false
    end

    if !eva_insert(city_name,array_avg,log) then
      log.error('平均値の更新処理でエラーが発生したため、処理を終了します')
      return false
    end

    if !eva_latest(city_name,eva_value,log) then
      log.error('しきい値の設定処理でエラーが発生したため、処理を終了します')
      return false
    end

    if !eva_decision(city_name,array_avg,delay_date,log) then
      log.error('通知の判定処理でエラーが発生したため、処理を終了します')
      return false
    end
    if delay_date != 0 then
      if !delay_noti(delay_date) then
        return false
      end
    else
      log.info(" 本日、JRは正常に運行する見込みです")
    end
    return true
  rescue
    return false
  end
end
