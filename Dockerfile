# Step 1: Build Stage
FROM gradle:8.5-jdk17-alpine AS builder

WORKDIR /app
# Gradle 설정 파일들을 먼저 복사하여 의존성 캐싱 최적화
COPY build.gradle settings.gradle ./
COPY gradle/ gradle/
# 의존성만 먼저 다운로드 (캐싱 효율성 향상)
RUN gradle dependencies --no-daemon --quiet
# 소스 코드 복사
COPY . .
# WAR 파일 빌드 (테스트 제외하여 빌드 시간 단축)
RUN gradle clean bootWar -x test --no-daemon

# 생성된 WAR 파일 확인 (디버깅용)
RUN ls -la /app/build/libs/

# Runtime Stage (경량 최적화)
#FROM tomcat:10.1-jre17
FROM temurin-17-jre-slim-alpine

ENV TZ=Asia/Seoul
# 1) 타임존, 2) 불필요 기본앱 삭제, 3) 권한/디렉터리 작업
RUN set -eux; \
    ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone; \
    rm -rf /usr/local/tomcat/webapps/*; \
    mkdir -p /usr/local/tomcat/logs; \
    chmod -R 755 /usr/local/tomcat

# WAR만 복사 (캐시 효율을 위해 파일명 고정 권장)
COPY --from=builder /app/build/libs/ROOT.war /usr/local/tomcat/webapps/ROOT.war

# tomcat 사용자 실행 (권한 변경은 필요 시에만)
USER 1001

EXPOSE 8080

CMD ["catalina.sh", "run"]
