FROM openjdk:8
ADD target/bootcamp-0.0.1-SNAPSHOT.jar bootcamp-0.0.1-SNAPSHOT.jar
EXPOSE 8888
ENTRYPOINT ["java","-jar","/bootcamp-0.0.1-SNAPSHOT.jar"]
