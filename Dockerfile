FROM openjdk:8
ADD target/bootcamp-0.0.1-SNAPSHOT.jar bootcamp-0.0.1-SNAPSHOT.jar
EXPOSE 8888
ENTRYPOINT ["java","-jar","/my-test-app-0.0.1-SNAPSHOT.jar"]
