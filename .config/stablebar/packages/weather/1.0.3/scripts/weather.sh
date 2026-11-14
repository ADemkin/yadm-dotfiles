#!/bin/sh
set -e

json_escape() {
  printf '%s' "$1" | tr -d '\000-\037' | sed 's/\\/\\\\/g; s/"/\\"/g'
}

read_json() {
  printf '%s' "$weather" | plutil -extract "$1" raw -o - -
}

weather=$(curl -fsS --max-time 12 "https://wttr.in/$(printf '%s' "$LOCATION" | tr ' ' +)?format=j1")

if [ "$UNITS" = imperial ]; then
  degrees=F speed=Miles speed_unit="mph"
else
  degrees=C speed=Kmph speed_unit="km/h"
fi

temperature=$(read_json "current_condition.0.temp_$degrees")
feels_like=$(read_json "current_condition.0.FeelsLike$degrees")
humidity=$(read_json current_condition.0.humidity)
wind=$(read_json "current_condition.0.windspeed$speed")
wind_direction=$(read_json current_condition.0.winddir16Point)
condition=$(read_json current_condition.0.weatherDesc.0.value)
place=$(read_json nearest_area.0.areaName.0.value)
high=$(read_json "weather.0.maxtemp$degrees")
low=$(read_json "weather.0.mintemp$degrees")

condition=$(json_escape "$condition")
place=$(json_escape "$place")
printf '{"text":"%s°%s","tooltip":"%s","fields":{"place":"%s","condition":"%s"},"lists":{"details":[' "$temperature" "$degrees" "$condition" "$place" "$condition"
printf '{"label":"Feels like","value":"%s°%s"},' "$feels_like" "$degrees"
printf '{"label":"Humidity","value":"%s%%"},' "$humidity"
printf '{"label":"Wind","value":"%s %s %s"},' "$wind" "$speed_unit" "$wind_direction"
printf '{"label":"High","value":"%s°%s"},' "$high" "$degrees"
printf '{"label":"Low","value":"%s°%s"}' "$low" "$degrees"
printf ']}}\n'
