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

# Step 2: Runtime Stage - JRE 사용으로 크기 최적화
FROM tomcat:10.1-jre17 AS runtime

# 필요한 패키지 설치 (curl for healthcheck, tzdata for timezone)
RUN apt-get update && apt-get install -y curl && rm -rf /var/lib/apt/lists/*

# 타임존 설정
ENV TZ=Asia/Seoul
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

# 불필요한 기본 앱들 삭제하여 크기 최적화
RUN rm -rf /usr/local/tomcat/webapps/* && \
    rm -rf /usr/local/tomcat/logs/* && \
    mkdir -p /usr/local/tomcat/logs

# WAR 파일 복사
COPY --from=builder /app/build/libs/ROOT.war /usr/local/tomcat/webapps/ROOT.war

# JSP 컴파일을 위한 추가 설정
ENV CATALINA_OPTS="-Djava.awt.headless=true -Dfile.encoding=UTF-8"

EXPOSE 8080

# 헬스체크 추가
HEALTHCHECK --interval=30s --timeout=3s --start-period=60s --retries=3 \
    CMD curl -f http://localhost:8080/ || exit 1

CMD ["catalina.sh", "run"]
