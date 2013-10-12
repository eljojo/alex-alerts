require_relative '../alex_alert.rb'

# http://stackoverflow.com/questions/1819614/how-do-i-globally-configure-rspec-to-keep-the-color-and-format-specdoc-o
RSpec.configure do |config|
  # Use color in STDOUT
  config.color_enabled = true

  # Use color not only in STDOUT but also in pagers and files
  config.tty = true

  # Use the specified formatter
  config.formatter = :documentation # :progress, :html, :textmate
  config.filter_run_including :focus => true
  config.run_all_when_everything_filtered = true
end
