#FROM nginx:1.27-alpine
#
## 패키지 설치
#RUN apk add --no-cache curl tzdata bind-tools && \
#    rm -rf /var/cache/apk/*
#
## 기본 설정 파일 제거
#RUN rm /etc/nginx/conf.d/default.conf
#
## 설정 파일 복사
#COPY default.conf /etc/nginx/conf.d/
#
## 로그 디렉토리 설정
#RUN mkdir -p /var/log/nginx && \
#    touch /var/log/nginx/access.log /var/log/nginx/error.log
#
#
#EXPOSE 80
#CMD ["nginx", "-g", "daemon off;"]

FROM nginx:1.27-alpine

# 선택: 기본 default.conf를 유지하려면 COPY를 생략해도 됨
# 커스텀 설정을 쓰려면 default.conf를 그대로 덮어씁니다.
COPY default.conf /etc/nginx/conf.d/default.conf

EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]