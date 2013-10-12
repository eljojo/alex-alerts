require 'json'
require 'open-uri'

class WeatherAlert
  API_KEY = '897b0ecd61d57e6e'

  class << self
    def query_url(city = 'Berlin,Germany')
      "http://api.wunderground.com/api/#{API_KEY}/alerts/q/#{city}.json"
    end

    def all
      $log.info "querying #{query_url}"
      raw_json = open(query_url).read # rescue nil
      result = JSON.parse raw_json # rescue {}

      return [] unless result["alerts"] and result["alerts"].any?
      result["alerts"].map do |alert|
        self.new(
          type: alert["type"],
          name: alert["wtype_meteoalarm_name"],
          color: alert["level_meteoalarm_name"],
          desc: alert["level_meteoalarm_description"]
        )
      end
    end
  end

  attr_accessor :type, :color, :name, :desc

  def initialize(default_attributes = {})
    default_attributes.each do |name, value|
      send("#{name}=", value) if respond_to?("#{name}=")
    end
  end

  def short_desc
    return '' unless desc
    desc.split(".").first
  end
end
