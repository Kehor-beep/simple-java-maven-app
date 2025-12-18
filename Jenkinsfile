pipeline {
    agent any

parameters {
        booleanParam(
            name: 'DEPLOY',
            defaultValue: true,
            description: 'Deploy after successful build?'
        )
        choice(
            name: 'ENV',
            choices: ['local', 'skip'],
            description: 'Where to deploy the app'
        )
    }

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

stage('Deploy Locally') {
    when {
        allOf {
            expression { params.DEPLOY }
            expression { params.ENV == 'local' }
        }
    }
    steps {
        sh """
          echo "Stopping old container if exists..."
          docker stop simple-java-maven-app || true

          echo "Removing old container if exists..."
          docker rm simple-java-maven-app || true

          echo "Pulling latest image from Docker Hub..."
          docker pull camildockerhub/simple-java-maven-app-1:latest

          echo "Running new container on host port 8081..."
          docker run -d --name simple-java-maven-app -p 8081:8080 camildockerhub/simple-java-maven-app-1:latest
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

