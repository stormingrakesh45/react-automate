pipeline {
    agent any

    environment {
        NODE_VERSION = "22" // if you want a specific Node version 
    }

    stages {
        stage('Checkout Code') {
            steps {
                echo "Cloning repository..."
                git branch: 'main',
                    url: 'https://github.com/stormingrakesh45/react-automate.git'
            }
        }

        stage('Install Dependencies') {
            steps {
                echo "Installing npm packages..."
                sh 'npm install'
            }
        }

        stage('Build React App') {
            steps {
                echo "Building React app..."
                sh 'npm run build'
            }
        }
    }

    post {
        success {
            echo 'Build successful!'
        }
        failure {
            echo 'Build failed!'
        }
    }
}
