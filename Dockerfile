# Step 1: Build Stage
FROM gradle:8.5-jdk17-alpine AS builder

WORKDIR /app

# Gradle wrapper와 설정 파일들 복사
COPY gradle/ gradle/
COPY gradlew build.gradle settings.gradle ./

# Windows CRLF -> Unix LF 변환 및 실행 권한 부여
RUN sed -i 's/\r$//' gradlew && chmod +x gradlew

# 또는 dos2unix 사용하는 방법
# RUN apk add --no-cache dos2unix && dos2unix gradlew && chmod +x gradlew

# 의존성 다운로드
RUN ./gradlew dependencies --no-daemon --quiet

# 소스 코드 복사
COPY . .

# JAR 빌드
RUN ./gradlew clean bootJar -x test --no-daemon

# Step 2: Runtime Stage
FROM eclipse-temurin:17-jre-alpine

ENV TZ=Asia/Seoul
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

# wget 설치 (헬스체크용)
RUN apk add --no-cache wget

# 비 root 사용자 생성
RUN addgroup -g 1001 spring && adduser -u 1001 -G spring -s /bin/sh -D spring

WORKDIR /app
COPY --from=builder /app/build/libs/*.jar app.jar
RUN chown spring:spring app.jar

USER spring
EXPOSE 8080

HEALTHCHECK --interval=30s --timeout=3s --start-period=60s --retries=3 \
    CMD wget --no-verbose --tries=1 --spider http://localhost:8080/actuator/health || exit 1

ENTRYPOINT ["java", "-jar", "/app/app.jar"]
