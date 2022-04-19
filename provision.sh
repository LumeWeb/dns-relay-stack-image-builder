#!/bin/sh

service ssh stop
cd /opt/dnsrelay && docker-compose up -d
service ssh start
