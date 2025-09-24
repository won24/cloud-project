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
## 시간대 설정
#ENV TZ=Asia/Seoul
#
#EXPOSE 80
#CMD ["nginx", "-g", "daemon off;"]

FROM nginx:1.27-alpine

COPY default.conf /etc/nginx/conf.d/default.conf

EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]