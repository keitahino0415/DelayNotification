require 'net/http'
require 'net/https'
require 'uri'
require 'json'
require 'sqlite3'
require 'date'

def geocode(city_name)


  uri_decode = URI::escape("https://maps.googleapis.com/maps/api/geocode/json?address=#{city_name}")

  uri = URI.parse(uri_decode)
  json = Net::HTTP.get(uri)
  result =  JSON.parse(json)
  root_json = result["results"][0]["geometry"]["location"]

  db_name = result["results"][0]["address_components"][0]["long_name"]
  lat = root_json["lat"]
  lng = root_json["lng"]

  return db_name,lat,lng

end
