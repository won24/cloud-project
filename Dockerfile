# Step 1: Build Stage
FROM gradle:8.5-jdk17-alpine AS builder

WORKDIR /app
COPY build.gradle settings.gradle ./
COPY gradle/ gradle/
RUN gradle dependencies --no-daemon
COPY . .
RUN gradle bootJar -x test --no-daemon
RUN java -Djarmode=layertools -jar build/libs/*.jar extract

# Step 2: Runtime Stage
FROM eclipse-temurin:17-jre-alpine AS runtime

# 보안 업데이트 및 필수 패키지 설치
RUN apk update && apk upgrade && \
    apk add --no-cache tzdata curl netcat-openbsd && \
    rm -rf /var/cache/apk/* && \
    addgroup -g 1001 -S springboot && \
    adduser -u 1001 -S springboot -G springboot

WORKDIR /app

# 레이어별로 복사 (캐시 최적화)
COPY --from=builder app/dependencies/ ./
COPY --from=builder app/spring-boot-loader/ ./
COPY --from=builder app/snapshot-dependencies/ ./
COPY --from=builder app/application/ ./

# 권한 설정
RUN chown -R springboot:springboot /app
USER springboot

# 시간대 설정
ENV TZ=Asia/Seoul

# JVM 메모리 최적화
ENV JAVA_OPTS="-Xms256m -Xmx512m -XX:+UseG1GC -XX:+UseStringDeduplication"

# 환경 변수 기본값 설정
ENV SPRING_PROFILES_ACTIVE=production
ENV SERVER_PORT=8080

# 포트 노출
EXPOSE 8080

# 헬스체크 추가
HEALTHCHECK --interval=30s --timeout=10s --start-period=60s \
    CMD curl -f http://localhost:${SERVER_PORT}/actuator/health || exit 1

# LayerTools 방식으로 실행
ENTRYPOINT ["java", "org.springframework.boot.loader.JarLauncher"]