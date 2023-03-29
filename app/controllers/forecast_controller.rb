class ForecastController < ApplicationController
  def index
    @address = params[:address]
    if @address.present?
      geocode_result = Geocoder.search(@address).first
      if geocode_result.present?
        @latitude, @longitude = geocode_result.coordinates
        @units = params[:units] || 'imperial'
        @forecast_data = Rails.cache.fetch("#{@address}_#{@units}", expires_in: 30.minutes) do
          retrieve_forecast_data(@latitude, @longitude)
        end
        if @forecast_data.present?
          @current_temp = temperature_in_units(@forecast_data['main']['temp'], @units)
          @high_temp = temperature_in_units(@forecast_data['main']['temp_max'], @units)
          @low_temp = temperature_in_units(@forecast_data['main']['temp_min'], @units)
          @extended_forecast = @forecast_data['weather'][0]['description']
        end
      end
    end
  end

  private

  def retrieve_forecast_data(latitude, longitude)
    url = "https://api.openweathermap.org/data/2.5/weather?lat=#{latitude}&lon=#{longitude}&appid=#{ENV['OPENWEATHER_API_KEY']}"
    response = HTTParty.get(url)
    if response.success?
      @forecast_data = JSON.parse(response.body)
    else
      @forecast_data = nil
    end
  rescue StandardError => e
    Rails.logger.error("Error retrieving forecast data: #{e.message}")
    @forecast_data = nil
  end

  def temperature_in_units(temp, units)
    case units
    when 'metric'
      temp.to_i
    when 'imperial'
      ((temp - 273.15) * 9 / 5 + 32).round
    else
      temp.to_i
    end
  end
end