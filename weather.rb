# coding: utf-8
require 'net/http'
require 'net/https'
require 'uri'
require 'json'
require 'OpenSSL'
require 'sqlite3'

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
  api_key = "a8fe10ee1619eadb53849afee0eb18cc"
  uri = URI.parse("http://api.openweathermap.org/data/2.5/find?q=#{city_name},jp&units=metric&APPID=#{api_key}")

  json = Net::HTTP.get(uri)
  result =  JSON.parse(json)
  return result
end

def post_weather(weather_array)


# weather_array.each {|weather|
#   puts weather
# }

#     uri = URI.parse("https://script.google.com/macros/s/AKfycbycd6cPkZqPLuN1ypTvKj1U2as71FfO3dp1bdsFazUYibEOR7M/exec")
#     uri = URI.parse("https://script.google.com/macros/s/AKfycbyREn7jEXyje1hhMIJZPzvQW2fJaPrAqmLpsn7fmCA/dev")
#     uri = URI.parse("https://script.google.com/macros/s/AKfycbycd6cPkZqPLuN1ypTvKj1U2as71FfO3dp1bdsFazUYibEOR7M/exec")
     # uri = URI.parse("https://script.google.com/macros/s/AKfycbycd6cPkZqPLuN1ypTvKj1U2as71FfO3dp1bdsFazUYibEOR7M/exec")
     # http = Net::HTTP.new(uri.host, uri.port)
     # http.use_ssl = true
     # http.verify_mode = OpenSSL::SSL::VERIFY_NONE
     #
     # puts weather_json
     # req = Net::HTTP::Post.new(uri.path)
#     req.set_form_data(weather_json)

     res = http.request(req)
     puts res
     return
end

def weather_main(city_name)
  result = get_weather(city_name)

  #ルート設定
  root_json = result["list"][0]

  #値セット
  wind_speed = root_json["wind"]["speed"]
  wind_deg = get_direction(root_json["wind"]["deg"])
  rain_check = get_stat(root_json["rain"])
  snow_check = get_stat(root_json["snow"])
  weather_array = []

  #確認用
  puts city_name
  puts " 雨:" << rain_check.to_s
  puts " 雪:" << snow_check.to_s
  puts " 風向き:" << wind_deg.to_s
  puts " 風速:" << wind_speed.to_s << "m/s"

  weather_json = JSON.generate({"weather" => { \
                                "city_name" => city_name \
                              , "rain_check" => rain_check \
                              , "snow_check" => snow_check \
                              , "wind_deg" => wind_deg \
                              , "wind_speed" => wind_speed}})

  test_hash =   {"weather" => { \
                  "city_name" => city_name \
                , "rain_check" => rain_check \
                , "snow_check" => snow_check \
                , "wind_deg" => wind_deg \
                , "wind_speed" => wind_speed}}

  weather_array << city_name
  weather_array << rain_check
  weather_array << snow_check
  weather_array << wind_deg
  weather_array << wind_speed

  puts weather_array[0]

  #post_weather(weather_array)
#  puts weather_json

end
