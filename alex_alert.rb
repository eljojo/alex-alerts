require_relative './weather_alert.rb'
require 'logger'
require 'twitter'
require 'tempfile'
require_relative './twitter_credentials.rb'

$log = Logger.new(STDOUT)

class AlexAlert
  def initialize(accounts, city: 'Berlin,Germany')
    @accounts = accounts
    @city = city
  end

  def warn_alex
    alerts = WeatherAlert.all(city: @city)
    return unless alerts.any?

    @accounts.each do |username, real_name|
      alert = alerts.sample
      message = "There's a #{alert.color} #{alert.name} alert right now! #{alert.short_desc}"
      tweet_message = "@#{username}: #{real_name}! #{message}"
      file = download(alert.pictures.sample)
      tweet(tweet_message, picture: file)
      if file then
        file.close
        file.unlink
      end
    end
  end

private
  def download(url)
    return if url.nil? or url.length == 0
    file = Tempfile.new("weather-image")
    begin
      open(url, 'rb')  { |read_file| file.write(read_file.read) }
      file.rewind
    rescue => e
      puts "error while downloading picture: #{e.message}"
      file.close
      file.unlink
      file = nil
    end
    file
  end

  def tweet(message, opts = {})
    if picture = opts.delete(:picture) then
      Twitter.update_with_media(message, picture) rescue nil
      $log.info "tweeting with picture: #{message}"
    else
      Twitter.update(message, opts) rescue nil
      $log.info "tweeting without picture: #{message}"
    end
  end
end

accounts = {
  myabc: 'Alex',
  wordgraphy: 'Guille',
  dg_tweety: 'Dajana',
  malweene: 'Malwine'
  # eljojo: 'jojo'
}

alex_alert = AlexAlert.new(accounts, city: 'Berlin,Germany')
alex_alert.warn_alex
