module ApplicationHelper
    def temperature_in_units(temp, units)
        if units == 'imperial'
          "#{temp.round}°F"
        elsif units == 'metric'
          "#{(temp - 273.15).round}°C"
        else
          "#{temp.round}K"
        end
      end
      
      def temperature_in_fahrenheit(temperature)
        (temperature - 273.15) * 9/5 + 32
      end
      
      def temperature_in_celsius(temperature)
        temperature - 273.15
      end
end
