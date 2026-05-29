pipeline {
    agent any

    environment {
        IMAGE_NAME = "myapp"
        EC2_IP     = "13.60.157.119" 
        EC2_USER   = "ec2-user"   
    }

    stages {
        stage('Checkout') {
            steps {
                git branch: 'main', url: 'https://github.com/SinReaksa/Testing.git'
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
                sshagent(credentials: ['ec2-server-key']) {
                    sh '''
                    # 1. Compress the local Docker image into a tar archive
                    docker save -o myapp.tar $IMAGE_NAME

                    # 2. Securely transfer the image using sshagent context
                    scp -o StrictHostKeyChecking=no myapp.tar ${EC2_USER}@${EC2_IP}:/home/${EC2_USER}/myapp.tar

                    # 3. Connect via SSH to load and execute the container
                    ssh -o StrictHostKeyChecking=no ${EC2_USER}@${EC2_IP} "
                        docker load -i /home/${EC2_USER}/myapp.tar &&
                        docker stop app || true &&
                        docker rm app || true &&
                        docker run -d -p 80:80 --name app $IMAGE_NAME &&
                        rm /home/${EC2_USER}/myapp.tar
                    "

                    # 4. Clean up local archive
                    rm myapp.tar
                    '''
                }
            }
        } // stage('Deploy') ends cleanly here
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