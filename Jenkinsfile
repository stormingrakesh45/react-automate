pipeline {
    agent {
        docker {
            image 'node:22'    // Use Node 22 instead of 18
            args '-v /var/run/docker.sock:/var/run/docker.sock'
        }
    }

    environment {
        DOCKER_IMAGE = "react-automate"
        DOCKERHUB_REPO = "rakeshbhai"
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

        stage('Build Docker Image') {
            steps {
                sh '''
                    docker build -t ${DOCKER_IMAGE}:latest .
                '''
            }
        }

        stage('Push Docker Image to Docker Hub') {
            steps {
                withCredentials([usernamePassword(
                    credentialsId: 'dockerhub_creds',
                    usernameVariable: 'USER',
                    passwordVariable: 'PASS'
                )]) {
                    sh '''
                        echo $PASS | docker login -u $USER --password-stdin
                        docker tag ${DOCKER_IMAGE}:latest $USER/${DOCKER_IMAGE}:latest
                        docker push $USER/${DOCKER_IMAGE}:latest
                    '''
                }
            }
        }

        stage('Deploy on EC2') {
            steps {
                sshagent(['rakesh-pem']) {
                    sh '''
                        ssh -o StrictHostKeyChecking=no ubuntu@52.91.154.113 <<EOF
                        echo "Pulling latest image..."
                        docker pull ${DOCKERHUB_REPO}/${DOCKER_IMAGE}:latest

                        echo "Stopping old container..."
                        docker stop ${DOCKER_IMAGE} || true
                        docker rm ${DOCKER_IMAGE} || true

                        echo "Starting new container..."
                        docker run -d -p 80:80 --name ${DOCKER_IMAGE} ${DOCKERHUB_REPO}/${DOCKER_IMAGE}:latest
                        EOF
                    '''
                }
            }
        }
    }
}
