FROM hertzg/rtl_433
RUN apk add --update tini python3 py3-pip
RUN pip3 install paho-mqtt
COPY rtl-433-mqtt-cmd.py /usr/bin/rtl-433-mqtt-cmd
ENV HOST="127.0.0.1"
ENV OPTIONS=""
ENV MQTT_USERNAME=""
ENV MQTT_PASSWORD=""
ENTRYPOINT ["/sbin/tini", "--"]
CMD ["/bin/sh", "-c", "/usr/bin/rtl-433-mqtt-cmd --host $HOST $OPTIONS"]