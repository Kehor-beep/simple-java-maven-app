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

        stage('Archive Artifact') {
            steps {
                archiveArtifacts artifacts: 'target/*.jar', fingerprint: true
            }
        }
    }
}

