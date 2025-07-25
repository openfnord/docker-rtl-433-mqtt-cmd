# docker-rtl-433-mqtt-cmd
Dockerfile and tools to enable sending rtl_433 commands via MQTT. Built upon hertzg/rtl_433.

## Motivation
The primary goal was to enable rtl_433 to periodically listen for temperature sensor updates, and switch to a TPMS frequency/protocol on-demand via MQTT.

## udev Rules
The included udev rule creates symlinks for RTL-SDR devices to a predictable path which can be referenced by Docker. Due to limitations of rtl_433, this symlink must be re-linked back to a /dev/bus/usb/XXX/YYY path within the container. This is handled by the entrypoint if RTL_DEVICE environment variable is set.

Additionally, by installing rtl-sdr on the host system appropriate udev rules are created to ensure the RTL device is accessible by the plugdev group.

## Compose Example
```yaml
services:
  rtl-433:
    image: rtl-433-mqtt-cmd:latest
    container_name: rtl-433
    restart: unless-stopped
    hostname: rtl-433
    environment:
      MQTT_USERNAME: user_name
      MQTT_PASSWORD: password
      RTL_DEVICE: "/dev/rtlsdr"
    devices:
      - "/dev/rtlsdr/by-id/usb-Realtek_RTL2838UHIDIR_00000001:/dev/rtlsdr"
```

## HomeAssistant Action Example
Request rtl_433 to received for 60s and publish back to MQTT.
```yaml
service: mqtt.publish
data:
  payload: |-
    {
      "cmd":"-R 162 -T 60s -C si -F mqtt://$HOST:1883,user=$MQTT_USERNAME,pass=$MQTT_PASSWORD",
      "timeout":65
    }
  topic: rtl-433-cmd/
```