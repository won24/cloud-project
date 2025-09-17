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

# 타임존 설정
ENV TZ=Asia/Seoul
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

# tomcat 사용자 확인 및 권한 설정
RUN id tomcat || useradd -r -u 1000 tomcat
RUN chown -R tomcat:tomcat /usr/local/tomcat
RUN chmod -R 755 /usr/local/tomcat

# 불필요한 기본 앱들 삭제하여 크기 최적화
RUN rm -rf /usr/local/tomcat/webapps/* && \
    rm -rf /usr/local/tomcat/logs/* && \
    mkdir -p /usr/local/tomcat/logs

# WAR 파일 복사 및 권한 설정
COPY --from=builder /app/build/libs/ROOT.war /usr/local/tomcat/webapps/ROOT.war
RUN chown tomcat:tomcat /usr/local/tomcat/webapps/ROOT.war

# tomcat 사용자로 실행
USER tomcat

EXPOSE 8080

# 헬스체크 추가
HEALTHCHECK --interval=30s --timeout=3s --start-period=60s --retries=3 \
    CMD curl -f http://localhost:8080/ || exit 1

CMD ["catalina.sh", "run"]
