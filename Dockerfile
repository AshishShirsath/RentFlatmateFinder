############################
# Angular Build
############################
FROM node:22 AS angular-build

WORKDIR /frontend

COPY rentflatmatefinder-ui/package*.json ./

RUN npm install

COPY rentflatmatefinder-ui .

RUN npx ng build rentflatmatefinder-ui --configuration production


############################
# Spring Boot Build
############################
FROM maven:3.9.9-eclipse-temurin-21 AS backend-build

WORKDIR /backend

COPY rentflatmatefinder .

RUN mvn clean package -DskipTests


############################
# Final Image
############################
FROM eclipse-temurin:21-jre

RUN apt-get update && \
    apt-get install -y nginx && \
    rm -rf /var/lib/apt/lists/*

WORKDIR /app

COPY --from=backend-build /backend/target/*.jar app.jar

COPY --from=angular-build /frontend/dist/rentflatmatefinder-ui/browser /usr/share/nginx/html

COPY nginx.conf /etc/nginx/sites-available/default

COPY start.sh /start.sh

RUN chmod +x /start.sh

EXPOSE 80

ENTRYPOINT ["/start.sh"]
