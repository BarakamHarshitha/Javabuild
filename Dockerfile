FROM ubuntu:22.04 AS build

RUN apt-get update && \
    apt-get install -y openjdk-17-jdk maven git && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

WORKDIR /app

COPY pom.xml ./
COPY src ./src

RUN mvn clean package

FROM ubuntu:22.04

RUN apt-get update && \
    apt-get install -y openjdk-17-jre && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

WORKDIR /app

COPY --from=build /app/target/*.jar /app/myapp.jar

ENTRYPOINT ["java", "-jar", "/app/myapp.jar"]
