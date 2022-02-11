## BUILD
FROM maven:3.8.4-openjdk-11-slim AS build

WORKDIR /home/app

COPY src src
COPY pom.xml pseudoPom.xml
RUN awk 'BEGIN {!p} p <=1|| p >=4 {print;} /plugin>/ {p++;}' pseudoPom.xml > pom.xml

RUN mvn -f /home/app/pom.xml clean package

## PACKAGE
FROM openjdk:11.0-jre-slim-buster

LABEL "${groupId}.${artifactId}"="${name}"
LABEL version=${version}
LABEL mantainer="${mantainer}"

COPY --from=build /home/app/target/${artifactId}-${version}.jar /usr/local/lib/${artifactId}.jar
CMD ["java","-jar","/usr/local/lib/${artifactId}.jar"]
