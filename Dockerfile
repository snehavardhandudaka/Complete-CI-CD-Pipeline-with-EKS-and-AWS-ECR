# Use an official OpenJDK runtime as a parent image
FROM openjdk:11-jre-slim

# Set the working directory in the container
WORKDIR /app

# Copy the JAR file from the host to the container
<<<<<<< HEAD
COPY target/my-java-app-1.0-SNAPSHOT.jar /app/my-java-app-1.0.jar

# Run the JAR file
ENTRYPOINT ["java", "-jar", "my-java-app-1.0.jar"]
=======
COPY target/my-java-app.jar /app/my-java-app.jar

# Run the JAR file
ENTRYPOINT ["java", "-jar", "my-java-app.jar"]
>>>>>>> f9504c34569526a1f6eff09023a2957314bc64b7

