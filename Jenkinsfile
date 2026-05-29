pipeline {
    agent any

    environment {
        IMAGE_NAME = "myapp"
    }

    stages {

        stage('Checkout') {
            steps {
                git branch: 'main',
                    url: 'https://github.com/SinReaksa/Testing.git'
            }
        }

        stage('Build Docker Image') {
            steps {
                sh 'docker build -t $IMAGE_NAME .'
            }
        }

        stage('Test') {
            steps {
                sh 'echo "Running tests..."'
            }
        }

        stage('Deploy') {
            steps {
                sh '''
                ssh -o StrictHostKeyChecking=no ec2-user@YOUR_EC2_IP "
                docker pull myapp || true &&
                docker stop app || true &&
                docker rm app || true &&
                docker run -d -p 80:3000 --name app myapp
                "
                '''
            }
        }
    }

    post {
        success {
            echo 'Deployment Successful'
        }
        failure {
            echo 'Deployment Failed'
        }
    }
}