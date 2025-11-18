pipeline {
    agent any

    // Define environment variables for deployment
    environment {
        // We'll use the Jenkins build number as the image tag
        DOCKER_IMAGE = "react-app-ci-cd:${env.BUILD_NUMBER}" 
        CONTAINER_NAME = "react-frontend-app"
        // Define the port on the EC2 host that will serve the application
        // Assuming your existing website is on 80. Let's use 8081 for this new app.
        HOST_PORT = 8081 
    }

    stages {
        stage('Checkout Code') {
            steps {
                // Since this is a Pipeline script from SCM, the code is automatically checked out,
                // but we can add an echo for clarity.
                echo 'Checking out code from Git...'
            }
        }
        
        stage('Cleanup Old Container') {
            steps {
                echo "Removing container ${CONTAINER_NAME} if it exists..."
                // The '|| true' ensures the pipeline doesn't fail if the container doesn't exist.
                sh "docker rm -f ${CONTAINER_NAME} || true" 
            }
        }

        stage('Build Docker Image') {
            steps {
                echo "Building Docker image ${DOCKER_IMAGE}..."
                // The '.' means build using the Dockerfile in the current workspace directory.
                sh "docker build -t ${DOCKER_IMAGE} ."
            }
        }

        stage('Deploy New Container') {
            steps {
                echo "Deploying new container on EC2 port ${HOST_PORT}..."
                // Run the new container, mapping the EC2 host port to the Nginx internal port 80.
                sh "docker run -d -p ${HOST_PORT}:80 --name ${CONTAINER_NAME} ${DOCKER_IMAGE}"
            }
        }
    }

    post {
        always {
            echo 'Pipeline job finished.'
        }
        success {
            echo "Successfully deployed to http://52.91.154.113:${HOST_PORT}"
        }
        failure {
            echo 'Deployment failed! Check the console output for errors.'
        }
    }
}