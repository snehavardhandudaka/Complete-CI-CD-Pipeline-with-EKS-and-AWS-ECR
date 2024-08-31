# Use an official OpenJDK runtime as a parent image
FROM openjdk:11-jre-slim

# Set the working directory in the container
WORKDIR /app

# Copy the JAR file from the host to the container
COPY target/my-java-app.jar /app/my-java-app.jar

# Run the JAR file
ENTRYPOINT ["java", "-jar", "my-java-app.jar"]

