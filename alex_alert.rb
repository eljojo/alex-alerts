require_relative './weather_alert.rb'
require 'logger'
require 'twitter'
require_relative './twitter_credentials.rb'

$log = Logger.new(STDOUT)
$client = Twitter::Client.new

class AlexAlert
  def initialize(name: '', twitter_handle: '', city: 'Berlin,Germany')
    @name = name
    @city = city
    @twitter_handle = twitter_handle
    find_alerts
  end

  def find_alerts
    @alerts = WeatherAlert.all(city: @city)
    @alerts.each { |alert| warn_alex(alert) }
  end

  def warn_alex(alert)
    message = "@#{@twitter_handle} #{@name}, be careful! There's a #{alert.color} #{alert.name} alert right now! #{alert.short_desc}"
    $log.info "tweeting: #{message}"
    $client.update(message)
  end
end

alex = AlexAlert.new(name: 'Alex', twitter_handle: 'myabc')
guille = AlexAlert.new(name: 'Guille', twitter_handle: 'wordgraphy')
