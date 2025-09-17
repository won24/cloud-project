# Step 1: Build Stage
FROM gradle:8.5-jdk17-alpine AS builder

WORKDIR /app
COPY build.gradle settings.gradle ./
COPY gradle/ gradle/
RUN gradle dependencies --no-daemon
COPY . .
RUN gradle bootJar -x test --no-daemon

# Step 2: Runtime Stage
FROM eclipse-temurin:17-jre-alpine AS runtime

# 보안 업데이트 및 필수 패키지 설치
RUN apk update && apk upgrade && \
    apk add --no-cache tzdata curl netcat-openbsd && \
    rm -rf /var/cache/apk/* && \
    addgroup -g 1001 -S springboot && \
    adduser -u 1001 -S springboot -G springboot

WORKDIR /app

# 단일 JAR 복사만 수행
COPY --from=builder /app/build/libs/*.jar app.jar

# 권한 설정
RUN chown -R springboot:springboot /app
USER springboot

# 환경 설정
ENV TZ=Asia/Seoul
ENV JAVA_OPTS="-Xms256m -Xmx512m -XX:+UseG1GC -XX:+UseStringDeduplication"
ENV SPRING_PROFILES_ACTIVE=production
ENV SERVER_PORT=8080

EXPOSE 8080

# 헬스체크
HEALTHCHECK --interval=30s --timeout=10s --start-period=60s \
    CMD curl -f http://localhost:${SERVER_PORT}/actuator/health || exit 1

# 단일 JAR 실행
ENTRYPOINT ["java", "-jar", "app.jar"]
