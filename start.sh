#!/bin/bash

service nginx start

tail -F /var/log/nginx/error.log &
tail -F /var/log/nginx/access.log &

exec java -jar /app/app.jar
