require 'net/http'
require 'net/https'
require 'uri'
require 'json'
require 'OpenSSL'
require 'sqlite3'
require 'date'

def notification_get(array_avg,db,log)
  begin
    log.info("    #{__method__}　Start")
    array_avg.push(db.execute "SELECT ROUND(AVG(wind_speed),2) FROM Log;")
    log.info("    #{__method__}　NormalEnd")
    return true
  rescue
    log.error("    #{__method__} AbnormalEnd")
    return false
  ensure
  end
end

def evaluation_insert(array_avg,db,log)
  begin
    log.info("    #{__method__} Start")
    db.execute "INSERT INTO evaluation (Wind_Avg) VALUES(#{array_avg[0][0][0]});"
    proc_line = db.execute "SELECT changes();"

    if proc_line == 0
      return false
    end
    log.info("    #{__method__} NormalEnd")
    return true
  rescue
    log.error("    #{__method__} AbNormalEnd")
    return false
  ensure
  end
end

def evaluation_latest(eva_value,db,log)
  begin
    log.info("    #{__method__} Start")
    eva_value = db.execute "SELECT MAX(id),wind_avg FROM evaluation;"
    if eva_value[0][1].nil?
      return false
    end
    log.info("    #{__method__} NormalEnd")
    return true
  rescue
    log.error("    #{__method__} AbNormalEnd")
    return false
  ensure
  end
end

#次回ここから(しきい値と3,6,9時間後の風力を比較して、通知するか判定)
def evaluation_decision(city_name,array_avg,delay_date,log)

  #変数定義
  result = []
  weather_hash = {}
  count = 0

  begin
    log.info("    #{__method__} Start")
    if !weather_prediction(city_name,result) then
      return false
    end
    result[0]['list'][0].each do |list|
      weather_hash[result[0]['list'][count]['dt_txt']] = result[0]['list'][count]['wind']['speed']
      count = count + 1
    end
    weather_hash.each do |key,value|
      if array_avg[0][0][0] <= value then
        delay_date.push(key.gsub(" ","."))
      end
    end

    log.info("    #{__method__} NormalEnd")
    return true
  rescue
    log.error("    #{__method__} AbNormalEnd")
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

def notification_dalay(delay_date,log)
  begin
    log.info("    #{__method__} Start")
    buf = []
    count = 0

    buf << "本日、下記の時間帯にJRが遅延する恐れがあります"

    delay_date.each do |msg|
      buf << msg
    end

    message = <<-EOS
    #{buf.each do
      buf[count]
      count = count + 1
     end}
    EOS
    uri = URI.parse("https://notify-api.line.me/api/notify")
    request = Net::HTTP::Post.new(uri)
    request["Authorization"] = "Bearer jxYKtF5C7A0AYWp10m9adqrykZwuQIkQRXQVHm8L3hi"
    request.set_form_data(
      "message" => "#{message}",
    )

    req_options = {
      use_ssl: uri.scheme == "https",
    }

    response = Net::HTTP.start(uri.hostname, uri.port, req_options) do |http|
      http.request(request)
    end
    log.info("    #{__method__} NormalEnd")
  rescue
    log.error("    #{__method__} AbnormalEnd")
    return false
  end

end

def notification_main(city_name,log)

  begin
    #変数定義
    array_avg = []
    eva_value = []
    delay_date = []
    db = SQLite3::Database.open "../../DB/weather_db/#{city_name}.db"

    if !notification_get(array_avg,db,log) then
      return false
    end

    if !evaluation_insert(array_avg,db,log) then
      return false
    end

    if !evaluation_latest(eva_value,db,log) then
      return false
    end

    if !evaluation_decision(city_name,array_avg,delay_date,log) then
      return false
    end
    if delay_date != 0 then
      if !notification_dalay(delay_date,log) then
        return false
      end
    end
    return true
  rescue
    return false
  ensure
    db.close
  end
end
