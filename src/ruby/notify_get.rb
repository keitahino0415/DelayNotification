require 'sqlite3'

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
def eva_decision(log)
  begin
    log.info(' 通知判定処理 開始')

    log.info(' 通知判定処理 正常終了')
    return true
  rescue
    log.error(" 通知判定処理 異常終了")
    return false
  end
end
