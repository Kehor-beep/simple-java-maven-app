pipeline {
    agent any

    tools {
        jdk 'jdk21'
        maven 'maven3'
    }

    stages {
        stage('Checkout') {
            steps {
                // Checkout the same repo this Jenkinsfile lives in
                checkout scm
            }
        }

        stage('Test') {
            steps {
                sh 'mvn -B test'
            }
        }

        stage('Package') {
            steps {
                sh 'mvn -B clean package'
            }
        }

        stage('Build Docker Image') {
            steps {
                sh """
                  docker build -t simple-java-maven-app:${BUILD_NUMBER} -t simple-java-maven-app:latest .
                """
            }
        }

        stage('Push Docker Image') {
            steps {
                withCredentials([usernamePassword(
                    credentialsId: 'dockerhub-creds',
                    usernameVariable: 'DOCKERHUB_USER',
                    passwordVariable: 'DOCKERHUB_PASS'
                )]) {
                    sh """
                      echo "$DOCKERHUB_PASS" | docker login -u "$DOCKERHUB_USER" --password-stdin

                      docker tag simple-java-maven-app:${BUILD_NUMBER} $DOCKERHUB_USER/simple-java-maven-app-1:${BUILD_NUMBER}
                      docker tag simple-java-maven-app:${BUILD_NUMBER} $DOCKERHUB_USER/simple-java-maven-app-1:latest

                      docker push $DOCKERHUB_USER/simple-java-maven-app-1:${BUILD_NUMBER}
                      docker push $DOCKERHUB_USER/simple-java-maven-app-1:latest

                      docker logout
                    """
                }
            }
        }

        stage('Archive Artifact') {
            steps {
                archiveArtifacts artifacts: 'target/*.jar', fingerprint: true
            }
        }
    }
}

