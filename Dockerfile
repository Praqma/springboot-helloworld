ARG HELLOWORLD_VERSION

FROM maven:3.6.3-openjdk-8-slim AS build
ARG HELLOWORLD_VERSION
ENV HELLOWORLD_VERSION $HELLOWORLD_VERSION

COPY ./pom.xml ./pom.xml

RUN mvn -X --batch-mode \
        verify clean --fail-never

COPY ./src ./src

RUN mvn --batch-mode \
        clean package

FROM openjdk:8-jre-alpine
ARG HELLOWORLD_VERSION
ENV HELLOWORLD_VERSION $HELLOWORLD_VERSION

WORKDIR /home/application/java

COPY entrypoint.sh entrypoint.sh
COPY --from=build "/target/helloworld-${HELLOWORLD_VERSION}.jar" .
RUN chmod 700 helloworld-${HELLOWORLD_VERSION}.jar

EXPOSE 8080

ENTRYPOINT ["sh", "entrypoint.sh"]
