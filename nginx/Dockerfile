 # 최신 버전 사용
FROM nginx:1.27-alpine

# 패키지 설치
RUN apk add --no-cache curl tzdata bind-tools && \
    rm -rf /var/cache/apk/*

# 기본 설정 파일 제거
RUN rm /etc/nginx/conf.d/default.conf

# 설정 파일 복사
COPY default.conf /etc/nginx/conf.d/

# 로그 디렉토리 설정
RUN mkdir -p /var/log/nginx && \
    touch /var/log/nginx/access.log /var/log/nginx/error.log

# 시간대 설정
ENV TZ=Asia/Seoul

EXPOSE 80

# 헬스체크 개선 (DNS 해결 테스트 포함)
HEALTHCHECK --interval=30s --timeout=10s --start-period=60s --retries=3 \
    CMD curl -f http://localhost/health && nslookup bidonproject-springboot-service || exit 1

CMD ["nginx", "-g", "daemon off;"]