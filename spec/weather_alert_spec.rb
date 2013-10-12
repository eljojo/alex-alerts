require 'spec_helper'

describe WeatherAlert do
  describe '.all' do
    before do
      @alerts = WeatherAlert.all
    end

    it "loads weather alerts" do
      @alerts.should_not be_empty
    end

    it "returns WeatherAlert objects" do
      @alerts.first.should be_a WeatherAlert
    end
  end
end
