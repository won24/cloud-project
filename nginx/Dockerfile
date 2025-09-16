FROM nginx:1.25-alpine

# 불필요한 패키지 제거 및 필요 패키지 설치
RUN apk add --no-cache curl tzdata && \
    rm -rf /var/cache/apk/*

# 기본 설정 파일 제거
RUN rm /etc/nginx/conf.d/default.conf

# Nginx 설정 복사
COPY nginx.conf /etc/nginx/nginx.conf
COPY default.conf /etc/nginx/conf.d/

# 로그 디렉토리 설정
RUN mkdir -p /var/log/nginx && \
    touch /var/log/nginx/access.log /var/log/nginx/error.log

# 시간대 설정
ENV TZ=Asia/Seoul

# 포트 노출
EXPOSE 80

# 헬스체크
HEALTHCHECK --interval=30s --timeout=5s \
    CMD curl -f http://localhost/health || exit 1

CMD ["nginx", "-g", "daemon off;"]