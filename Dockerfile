FROM openjdk:8-jre-alpine
MAINTAINER DATAOJO
RUN mkdir -p /app
RUN ln -svf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime
ADD ./target/spring-boot-helloworld-1.0.0-SNAPSHOT.jar /app
WORKDIR /app
EXPOSE 8080
CMD ["java","-jar","spring-boot-helloworld-1.0.0-SNAPSHOT.jar"]
