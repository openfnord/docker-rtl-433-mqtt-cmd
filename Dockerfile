FROM hertzg/rtl_433
RUN apk add --update tini python3 py3-pip
RUN pip3 install paho-mqtt
COPY rtl-433-mqtt-cmd.py /usr/bin/rtl-433-mqtt-cmd
ENTRYPOINT ["/sbin/tini", "--"]
CMD ["/bin/sh", "-c", "/usr/bin/rtl-433-mqtt-cmd"]