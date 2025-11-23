pipeline {
    agent any

    stages {

        stage('Build Docker Image') {
            steps {
                sh 'docker build -t react-ci-cd-app .'
            }
        }

        stage('Stop Old Container') {
            steps {
                sh 'docker stop react-app || true'
                sh 'docker rm react-app || true'
            }
        }

        stage('Run New Container') {
            steps {
                sh 'docker run -d -p 80:80 --name react-app react-ci-cd-app'
            }
        }
    }
}
