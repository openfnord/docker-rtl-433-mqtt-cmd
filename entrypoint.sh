#!/usr/bin/env sh

# Custom entrypoint to symlink $RTL_DEVICE to rtl_433 friendly path
# Modified from https://gist.github.com/gwisp2/b68b0d7ecf8ec35a4d1ee7a9ea8552b8

if [ ! -z "$RTL_DEVICE" ]; then
    
  if [ ! -e "$RTL_DEVICE" ]; then
    echo "Device $RTL_DEVICE does not exist."
    exit 1
  fi

  # rtl_433 is only capable of finding device under /dev/bus/usb/XXX/YYY
  # So create a symlink from $RTL_DEVICE to /dev/bus/usb/XXX/YYY, where XXX and YYY match the host
  # See https://github.com/hertzg/rtl_433_docker/issues/14 for the discussion.
  USB_BUS_PATH="/dev/$(udevadm info "--name=$RTL_DEVICE" -q name)"

  if [ -z "$USB_BUS_PATH" ]; then
    echo "Could not find device via udev."
    exit 1
  fi

  if [ "$RTL_DEVICE" != "$USB_BUS_PATH" ] && [ ! -f "$USB_BUS_PATH" ]; then
      mkdir -p "$(dirname "$USB_BUS_PATH")"
      ln -s "$RTL_DEVICE" "$USB_BUS_PATH"
      echo "$RTL_DEVICE -> $USB_BUS_PATH"
  fi
else
  echo "RTL_DEVICE not set. No symlink created."
fi

# Create user and group with necessary permissions
addgroup -g $PLUGDEV_GID plugdev
adduser -D -H rtl -G plugdev

# Call tini with original command
exec su-exec rtl /sbin/tini -- "$@"