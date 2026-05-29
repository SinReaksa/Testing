pipeline {
    agent any

    environment {
        IMAGE_NAME = "myapp"
        // TODO: Replace with your actual EC2 Instance public IP address
        EC2_IP     = "13.60.157.119" 
        // TODO: Change to 'ubuntu' if your EC2 instance is running Ubuntu
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
                // Compiles your static Nginx site into a Docker image locally
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
                # 1. Compress the local Docker image into a tar file archive
                docker save -o myapp.tar $IMAGE_NAME

                # 2. Securely transfer the image tar file to your remote EC2 server
                # Note: This assumes your Jenkins user has its SSH keys configured or running on the same network context.
                scp -o StrictHostKeyChecking=no myapp.tar ${EC2_USER}@${EC2_IP}:/home/${EC2_USER}/myapp.tar

                # 3. SSH into the EC2 instance to load the image and spin up the web container
                ssh -o StrictHostKeyChecking=no ${EC2_USER}@${EC2_IP} "
                    # Load the transferred image archive back into Docker
                    docker load -i /home/${EC2_USER}/myapp.tar &&
                    
                    # Stop and remove the old container version safely if it exists
                    docker stop app || true &&
                    docker rm app || true &&
                    
                    # Spin up your fresh Bakery website container on port 80
                    docker run -d -p 80:80 --name app $IMAGE_NAME &&
                    
                    # Clean up the heavy temporary tar file from the host
                    rm /home/${EC2_USER}/myapp.tar
                "

                # 4. Clean up the local tar archive from your Jenkins workspace
                rm myapp.tar
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