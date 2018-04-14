# coding: utf-8
require 'net/http'
require 'net/https'
require 'uri'
require 'json'
require 'OpenSSL'
require 'sqlite3'
require 'date'

def get_direction(direction_no)
  case direction_no
    when 0..39 then wind_deg = "北"
    when 40..89 then wind_deg = "北東"
    when 90..139 then wind_deg = "東"
    when 140..179 then wind_deg = "南東"
    when 180..219 then wind_deg = "南"
    when 220..269 then wind_deg = "南西"
    when 270..309 then wind_deg = "西"
    when 310..360 then wind_deg = "北西"
  end
  return wind_deg
end

def get_stat(check_target)
  if check_target.nil?
    return true
  else
    return false
  end
end

def get_weather(city_name)
  api_key = 'a8fe10ee1619eadb53849afee0eb18cc'
  uri = URI.parse("http://api.openweathermap.org/data/2.5/find?q=#{city_name},jp&units=metric&APPID=#{api_key}")
  json = Net::HTTP.get(uri)
  result =  JSON.parse(json)
  code = result["count"]
  if code != 0
    return result
  else
    return false
  end

end

def weather_main(city_name,weather_array,log)
  begin
    log.info(' 天気取得処理 開始')
    if get_weather(city_name) != false
      result = get_weather(city_name)
    else
      puts '天気情報の取得に失敗しました。'
      puts "[#{city_name}]の名称が正しいか確認してください。"
      log.error("  [#{city_name}]の名称が正しいか確認してください。")
    end

    #ルート設定
    root_json = result["list"][0]

    #値セット
    wind_speed = root_json["wind"]["speed"]
    wind_deg = get_direction(root_json["wind"]["deg"])
    rain_check = get_stat(root_json["rain"])
    snow_check = get_stat(root_json["snow"])

    #戻り値用の配列にセット
    weather_array.push(Date.today)
    weather_array.push(city_name)
    weather_array.push(rain_check)
    weather_array.push(snow_check)
    weather_array.push(wind_deg)
    weather_array.push(wind_speed)

    log.info(' 天気取得処理 正常終了')
    return true
  rescue
    log.error(' 天気情報取得処理 異常終了')
    return false
  end

end
