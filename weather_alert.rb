require 'json'
require 'open-uri'
require_relative './google_image_search.rb'

class WeatherAlert
  API_KEY = '897b0ecd61d57e6e'

  class << self
    def query_url_for(city = 'Berlin,Germany')
      "http://api.wunderground.com/api/#{API_KEY}/alerts/q/#{city}.json"
    end

    def all(city: 'Berlin,Germany')
      url = query_url_for(city)
      $log.info "querying #{url}"
      raw_json = open(url).read rescue nil
      result = JSON.parse(raw_json) rescue {}

      return [] unless result["alerts"] and result["alerts"].any?
      result["alerts"].map do |alert|
        self.new(
          type: alert["type"],
          name: alert["wtype_meteoalarm_name"] || alert["description"],
          color: alert["level_meteoalarm_name"],
          desc: alert["level_meteoalarm_description"],
          city: city
        )
      end
    end
  end

  attr_accessor :city, :type, :color, :name, :desc

  def initialize(default_attributes = {})
    @image_search = GoogleImageSearch.new
    default_attributes.each do |name, value|
      send("#{name}=", value) if respond_to?("#{name}=")
    end
  end

  def short_desc
    return '' unless desc
    short_desc = desc.split(".").first
    "#{short_desc}." if short_desc and short_desc.length > 0
  end

  def pictures(search_query = "weather #{name} chaos")
    @images ||= @image_search.search(search_query)
    @images.map { |image| image[:url] }
  end
end
