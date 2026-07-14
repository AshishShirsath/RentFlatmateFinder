#!/bin/bash

java -jar /app/app.jar &


until nc -z 127.0.0.1 8080; do
    echo "Waiting for Spring Boot..."
    sleep 2
done

echo "Spring Boot is ready."

# Start nginx
nginx -g 'daemon off;'
