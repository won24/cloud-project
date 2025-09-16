# Step 1: Build Stage
FROM gradle:8.5-jdk17-alpine AS builder

WORKDIR /app
COPY . .
RUN gradle bootJar -x test

# Step 2: Runtime Stage
FROM openjdk:17-jre-alpine AS runtime

# 보안 및 성능 최적화
RUN adduser -D -s /bin/sh springboot && \
    apk add --no-cache tzdata curl

WORKDIR /app

# 빌드 스테이지에서 JAR 파일 복사
COPY --from=builder /app/build/libs/*.jar app.jar

# 권한 설정
RUN chown -R springboot:springboot /app
USER springboot

# 시간대 설정
ENV TZ=Asia/Seoul

# JVM 메모리 최적화 (ECS/EKS 환경에 맞게 조정 가능)
ENV JAVA_OPTS="-Xms256m -Xmx512m -XX:+UseG1GC -XX:+UseStringDeduplication"

# 환경 변수 기본값 설정
ENV SPRING_PROFILES_ACTIVE=production
ENV SERVER_PORT=8080

# 포트 노출
EXPOSE 8080

# 헬스체크 추가 (Spring Boot Actuator 필요)
HEALTHCHECK --interval=30s --timeout=10s --start-period=60s \
    CMD curl -f http://localhost:${SERVER_PORT}/actuator/health || exit 1

# 환경 변수를 JVM 파라미터로 전달
ENTRYPOINT ["sh", "-c", "java $JAVA_OPTS -Dspring.profiles.active=${SPRING_PROFILES_ACTIVE} -jar app.jar"]