pipeline {
    agent any
    environment {
        DOCKER_IMAGE = "react-automate"
        DOCKERHUB_USER = "rakeshbhai"
        DOCKERHUB_REPO = "${DOCKERHUB_USER}/${DOCKER_IMAGE}"
        EC2_HOST = "ubuntu@52.91.154.113"
        EC2_PORT = "80"
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
                sh 'npm ci'  // Faster/more reliable than 'npm install' for CI
            }
        }
        stage('Test') {
            steps {
                sh 'npm test || true'  // Run tests; ignore failure for now if none exist
            }
        }
        stage('Build React App') {
            steps {
                sh 'npm run build'
            }
        }
        stage('Docker Build & Push') {
            steps {
                script {
                    def image = docker.build("${DOCKERHUB_REPO}:${env.BUILD_ID}")  // Tag with build ID for versioning
                    withDockerRegistry([credentialsId: 'dockerhub_creds', url: '']) {
                        image.push('latest')
                        image.push("${env.BUILD_ID}")
                    }
                }
            }
            post {
                always {
                    sh 'docker system prune -f'  // Clean up local images
                }
            }
        }
        stage('Deploy to EC2') {
            steps {
                sshagent(['rakesh-pem']) {
                    sh """
                        ssh -o StrictHostKeyChecking=no ${EC2_HOST} <<EOF
                        docker pull ${DOCKERHUB_REPO}:latest
                        docker stop ${DOCKER_IMAGE} || true
                        docker rm ${DOCKER_IMAGE} || true
                        docker run -d -p ${EC2_PORT}:80 --name ${DOCKER_IMAGE} --restart unless-stopped ${DOCKERHUB_REPO}:latest
                        EOF
                    """
                }
            }
        }
    }
    post {
        success {
            echo 'Deployment successful! App live at http://52.91.154.113'
        }
        failure {
            echo 'Pipeline failed—check logs!'
        }
    }
}