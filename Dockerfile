# Step 1: Build Stage
FROM gradle:8.5-jdk17-alpine AS builder

WORKDIR /app
COPY build.gradle settings.gradle ./
COPY gradle/ gradle/
RUN gradle dependencies --no-daemon
COPY . .
RUN gradle bootWar -x test --no-daemon

# Step 2: Runtime Stage
FROM tomcat:10.1-jdk17-alpine AS runtime

# 기본 ROOT 앱 삭제
RUN rm -rf /usr/local/tomcat/webapps/ROOT

# WAR 파일 복사
COPY --from=builder /app/build/libs/*.war /usr/local/tomcat/webapps/ROOT.war

# 보안 설정
RUN addgroup -g 1001 -S tomcat && \
    adduser -u 1001 -S tomcat -G tomcat && \
    chown -R tomcat:tomcat /usr/local/tomcat
USER tomcat

ENV TZ=Asia/Seoul
EXPOSE 8080

CMD ["catalina.sh", "run"]
