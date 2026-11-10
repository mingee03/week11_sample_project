# 1단계: 빌드 환경 (Java 17 JDK)
FROM eclipse-temurin:17-jdk AS build
WORKDIR /app

# 소스 및 빌드 파일 복사
COPY gradlew .
COPY gradle gradle
COPY build.gradle .
COPY settings.gradle .
COPY src src

# gradlew 실행 권한 부여 및 JAR 파일 빌드 (테스트는 스킵하여 빌드 속도 향상)
RUN chmod +x ./gradlew
RUN ./gradlew bootJar -x test --no-daemon

# 2단계: 실행 환경 (Java 17 JRE)
FROM eclipse-temurin:17-jre
WORKDIR /app

# 1단계에서 빌드된 jar 파일 복사
COPY --from=build /app/build/libs/*.jar app.jar

EXPOSE 8080
ENTRYPOINT ["java", "-jar", "app.jar"]
