# Step 1: Build Stage
FROM gradle:8.5-jdk17-alpine AS builder

WORKDIR /app
COPY build.gradle settings.gradle ./
COPY gradle/ gradle/
RUN gradle dependencies --no-daemon --quiet
COPY . .
RUN gradle clean bootWar -x test --no-daemon
RUN ls -la /app/build/libs/

# Step 2: Runtime Stage (경량화만 제거)
FROM tomcat:10.1-jre17

ENV TZ=Asia/Seoul
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone
