# Build step
FROM alpine:latest AS build
RUN apk add --update build-base automake autoconf pkgconfig libusb-dev libudev-zero-dev linux-headers
WORKDIR /usbutils
COPY usbutils .
RUN ./autogen.sh && make

# Production step
FROM hertzg/rtl_433
RUN apk add --update tini python3 py3-pip py3-paho-mqtt eudev
COPY --from=build /usbutils/usbreset /usr/bin/usbreset
COPY rtl-433-mqtt-cmd.py /usr/bin/rtl-433-mqtt-cmd
COPY entrypoint.sh /usr/bin/entrypoint
ENV HOST="127.0.0.1"
ENV OPTIONS=""
ENV MQTT_USERNAME=""
ENV MQTT_PASSWORD=""
ENV RTL_DEVICE=""
ENTRYPOINT ["/usr/bin/entrypoint"]
CMD ["/bin/sh", "-c", "/usr/bin/rtl-433-mqtt-cmd --host $HOST $OPTIONS"]