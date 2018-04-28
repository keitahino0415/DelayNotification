require 'sqlite3'

#テーブル作成
def create_table(w_arr,db)
  db.execute "CREATE TABLE Log(Id INTEGER PRIMARY KEY,
      CreateDate TEXT, City_Name TEXT,Rain_Check TEXT,
      Snow_Check TEXT, Wind_Deg TEXT, Wind_Speed TEXT)"
  puts "#{w_arr[1]}を新しく作成したよ"
  # db.close
end

#テーブル存在チェック
def table_isexist(w_arr,db)
  count =  db.execute "SELECT COUNT(*) FROM sqlite_master WHERE type = 'table' AND name = 'Log';"
  if count[0][0].zero?
    return false
  else
    return true
  end
 end

def log_insert(w_arr,db,log)
  ret = db.execute "INSERT INTO Log(CreateDate,City_Name,Rain_Check,Snow_Check,Wind_Deg,Wind_Speed)
           VALUES ('#{w_arr[0]}' , '#{w_arr[1]}','#{w_arr[2]}','#{w_arr[3]}','#{w_arr[4]}','#{w_arr[5]}')"
  log.info("      Execution SQL-------------------------------------------------------------------------------------------")
  log.info("        INSERT INTO Log(CreateDate,City_Name,Rain_Check,Snow_Check,Wind_Deg,Wind_Speed)")
  log.info("        VALUES ('#{w_arr[0]}' , '#{w_arr[1]}','#{w_arr[2]}','#{w_arr[3]}','#{w_arr[4]}','#{w_arr[5]}')")
  log.info("      --------------------------------------------------------------------------------------------------------")

  puts ret
end

def log_update(w_arr,log)
  begin
    log.info("    #{__method__} Start")
    db = SQLite3::Database.open "../../DB/weather_db/#{w_arr[1]}.db"
    if table_isexist(w_arr,db) == false
      create_table(w_arr,db)
    end
    log_insert(w_arr,db,log)
    log.info("    #{__method__} NormalEnd")
    return  true
  rescue
    log.error("    #{__method__} AbnormalEnd")
    return false
  ensure
    db.close
  end
end
