pipeline {
    agent any

    environment {
        DOCKER_IMAGE = "react-automate"
        DOCKERHUB_USER = "rakeshbhai"
    }

    stages {

        stage('Checkout Code') {
            steps {
                git branch: 'main',
                    url: 'https://github.com/stormingrakesh45/react-automate.git'
            }
        }

        stage('Install Dependencies') {
            steps {
                sh 'npm install'
            }
        }

        stage('Build React App') {
            steps {
                sh 'npm run build'
            }
        }

        stage('Docker Build') {
            steps {
                sh '''
                    docker build -t ${DOCKER_IMAGE}:latest .
                '''
            }
        }

        stage('Push to Docker Hub') {
            steps {
                withCredentials([usernamePassword(
                    credentialsId: 'dockerhub_creds',
                    usernameVariable: 'USER',
                    passwordVariable: 'PASS'
                )]) {
                    sh '''
                        echo "$PASS" | docker login -u "$USER" --password-stdin
                        docker tag ${DOCKER_IMAGE}:latest $USER/${DOCKER_IMAGE}:latest
                        docker push $USER/${DOCKER_IMAGE}:latest
                    '''
                }
            }
        }

        stage('Deploy to EC2') {
            steps {
                sshagent(['rakesh-pem']) {
                    sh '''
                        ssh -o StrictHostKeyChecking=no ubuntu@52.91.154.113 <<EOF
                        docker pull ${DOCKERHUB_USER}/${DOCKER_IMAGE}:latest
                        docker stop ${DOCKER_IMAGE} || true
                        docker rm ${DOCKER_IMAGE} || true
                        docker run -d -p 80:80 --name ${DOCKER_IMAGE} ${DOCKERHUB_USER}/${DOCKER_IMAGE}:latest
                        EOF
                    '''
                }
            }
        }
    }
}
