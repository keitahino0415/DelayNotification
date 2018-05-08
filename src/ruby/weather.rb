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

def get_weather(city_name,result)

  weather_api_key = ENV['OPEN_WEATHER_APIKEY']
  uri = URI.parse("http://api.openweathermap.org/data/2.5/find?q=#{city_name},jp&units=metric&APPID=#{weather_api_key}")
  json = Net::HTTP.get(uri)

  result.push(JSON.parse(json))
  code = result[0]["count"]
  if code != 0
    return true
  else
    return false
  end

end

def weather_main(city_name,weather_array,log)
  begin
    #変数定義
    result = []

    log.info("    #{__method__} start")
    if !get_weather(city_name,result)
      log.error("      Please check that the name of the [#{city_name}] is correct")
      return false
    end

    #ルート設定
    root_json = result[0]["list"][0]

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

    log.info("    #{__method__} NormalEnd")
    return true
  rescue => error
    log.error("      #{error.message}")
    log.error("    #{__method__} AbNormalEnd")
    return false
  end

end
