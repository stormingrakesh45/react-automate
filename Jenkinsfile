pipeline {
    agent any

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
                sh 'docker build -t react-automate .'
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
                        docker tag react-automate $USER/react-automate:latest
                        docker push $USER/react-automate:latest
                    '''
                }
            }
        }

        stage('Deploy on EC2') {
            steps {
                sshagent(['rakesh-pem']) {
                    sh '''
                        ssh -o StrictHostKeyChecking=no ubuntu@52.91.154.113 <<EOF
                        docker pull rakeshbhai/react-automate:latest
                        docker stop react-automate || true
                        docker rm react-automate || true
                        docker run -d -p 80:80 --name react-automate rakeshbhai/react-automate:latest
                        EOF
                    '''
                }
            }
        }
    }
}
