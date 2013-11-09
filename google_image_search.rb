require 'open-uri'
require 'json'
class GoogleImageSearch
  ENDPOINT = 'http://ajax.googleapis.com/ajax/services/search/images'

  attr_reader :last_result

  def initialize
    @cache = {}
  end

  def search(search_query)
    @cache[search_query] ||= open(query_url(search_query)).read
    parsed_result = JSON.parse(@cache[search_query])
    return [] unless parsed_result["responseData"]
    @last_result = clean_results(parsed_result["responseData"]["results"])
  end

private
  def query_url(query)
    encoded_params = URI.encode_www_form(
      v: '1.0', rsz: '8', q: query, safe: 'active'
    )
    URI.parse("#{ENDPOINT}?#{encoded_params}")
  end
  def clean_results(results)
    results.map do |item|
      { title: item["titleNoFormatting"], url: item["url"] }
    end
  end
end
