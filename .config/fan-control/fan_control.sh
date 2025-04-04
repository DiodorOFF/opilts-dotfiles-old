#!/bin/bash
# Simple fan control script using wiringOP with cooldown period

# Configuration
WIRING_PIN=2       # WiringPi pin for physical pin 7 (PWM.0)
TEMP_THRESHOLD=50  # Temperature threshold in °C
POLL_INTERVAL=5    # Check every 5 seconds
COOLDOWN_TIME=60   # Fan cooldown time in seconds (12 cycles of 5 seconds each)

# Setup
echo "Setting up fan control on pin $WIRING_PIN..."
gpio mode $WIRING_PIN out
gpio write $WIRING_PIN 0
fan_on=0
cooldown_counter=0

# Clean exit
function cleanup {
  echo "Stopping fan and exiting..."
  gpio write $WIRING_PIN 0
  exit 0
}

trap cleanup SIGINT SIGTERM

echo "Fan control started. Threshold: ${TEMP_THRESHOLD}°C, Cooldown: ${COOLDOWN_TIME}s"

# Main loop
while true; do
  # Read CPU temperature (in millidegrees Celsius)
  temp_raw=$(cat /sys/class/thermal/thermal_zone0/temp)
  temp=$(echo "scale=1; $temp_raw/1000" | bc)
  
  # Decide fan state based on temperature and cooldown
  if (( $(echo "$temp >= $TEMP_THRESHOLD" | bc -l) )); then
    # Above threshold - turn on fan and reset cooldown
    should_be_on=1
    cooldown_counter=$((COOLDOWN_TIME / POLL_INTERVAL))
  else
    # Below threshold - check cooldown counter
    if [ $cooldown_counter -gt 0 ]; then
      # Still in cooldown period - keep fan running
      should_be_on=1
      cooldown_counter=$((cooldown_counter - 1))
      remaining_time=$((cooldown_counter * POLL_INTERVAL))
      cooldown_msg=", Cooldown: ${remaining_time}s remaining"
    else
      # Cooldown complete - can turn off fan
      should_be_on=0
      cooldown_msg=""
    fi
  fi
  
  # Update fan if needed
  if [ $should_be_on -ne $fan_on ]; then
    gpio write $WIRING_PIN $should_be_on
    fan_on=$should_be_on
    if [ $fan_on -eq 1 ]; then
      echo "CPU Temp: ${temp}°C, Fan: ON"
    else
      echo "CPU Temp: ${temp}°C, Fan: OFF"
    fi
  else
    if [ $fan_on -eq 1 ]; then
      echo "CPU Temp: ${temp}°C (Fan unchanged: ON)${cooldown_msg:-}"
    else
      echo "CPU Temp: ${temp}°C (Fan unchanged: OFF)"
    fi
  fi
  
  # Wait before next check
  sleep $POLL_INTERVAL
done