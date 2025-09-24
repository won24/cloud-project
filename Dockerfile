FROM gradle:8.5-jdk17-alpine AS builder

WORKDIR /app
COPY gradle/ gradle/
COPY gradlew build.gradle settings.gradle ./
RUN chmod +x gradlew
RUN ./gradlew dependencies --no-daemon --quiet

COPY . .
RUN ./gradlew clean bootJar -x test --no-daemon

# Distroless 이미지 사용
FROM gcr.io/distroless/java17-debian12

ENV TZ=Asia/Seoul
WORKDIR /app
COPY --from=builder /app/build/libs/*.jar app.jar

EXPOSE 8080
ENTRYPOINT ["java", "-jar", "/app/app.jar"]
