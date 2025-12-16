# Use a lightweight Java 21 runtime image
FROM eclipse-temurin:21-jre

# Create and switch to app directory inside the container
WORKDIR /app

# Copy the built jar from the build context into the container
COPY target/my-app-1.0-SNAPSHOT.jar app.jar

# Run the app when the container starts
CMD ["java", "-jar", "app.jar"]

