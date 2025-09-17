# Step 1: Build Stage
FROM gradle:8.5-jdk17-alpine AS builder

WORKDIR /app
COPY build.gradle settings.gradle ./
COPY gradle/ gradle/
RUN gradle dependencies --no-daemon
COPY . .
RUN gradle clean bootWar -x test --no-daemon  # bootWar 사용

# Step 2: Runtime Stage
FROM tomcat:10.1-jdk17 AS runtime

# 기본 ROOT 앱 삭제
RUN rm -rf /usr/local/tomcat/webapps/ROOT

# WAR 파일 복사
COPY --from=builder /app/build/libs/ROOT.war /usr/local/tomcat/webapps/ROOT.war

# 타임존 설정
ENV TZ=Asia/Seoul

EXPOSE 8080

CMD ["catalina.sh", "run"]
