pipeline {
    agent any

    tools {
        maven 'Maven 3.8.7' // Ensure this Maven version is configured in Jenkins
    }

    environment {
        AWS_REGION = 'us-east-2' // AWS region
        ECR_REPO = '761018874575.dkr.ecr.us-east-2.amazonaws.com/my-java-app-repo' // ECR repository URI
        IMAGE_TAG = "${env.BUILD_ID}" // Jenkins build ID for tagging
    }

    stages {
        stage('Checkout') {
            steps {
                git url: 'https://github.com/snehavardhandudaka/Complete-CI-CD-Pipeline-with-EKS-and-AWS-ECR.git', credentialsId: 'git-credentials-id' // Git credentials ID
                sh 'ls -la' // Verify the files in the workspace
            }
        }

        stage('Verify Files') {
            steps {
                sh 'ls -la' // Additional file verification
            }
        }

        stage('Pre-clean Workspace') {
            steps {
                sh 'rm -rf target' // Clean up old build artifacts
            }
        }

        stage('Build Maven Project') {
            steps {
                dir('Complete-CI-CD-Pipeline-with-EKS-and-AWS-ECR') {
                    sh 'mvn clean install' // Build the Maven project
                }
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    dockerImage = docker.build("${ECR_REPO}:${IMAGE_TAG}", 'Complete-CI-CD-Pipeline-with-EKS-and-AWS-ECR') // Build Docker image
                    echo "Built Docker image: ${ECR_REPO}:${IMAGE_TAG}"
                }
            }
        }

        stage('Authenticate Docker to AWS ECR') {
            steps {
                withCredentials([[$class: 'AmazonWebServicesCredentialsBinding', credentialsId: 'aws-credentials-id']]) { // AWS credentials ID
                    script {
                        sh '''
                        echo "Fetching ECR login password:"
                        aws ecr get-login-password --region ${AWS_REGION} | docker login --username AWS --password-stdin ${ECR_REPO}
                        if [ $? -ne 0 ]; then
                            echo "Docker login to ECR failed"
                            exit 1
                        fi
                        '''
                    }
                }
            }
        }

        stage('Push to AWS ECR') {
            steps {
                script {
                    docker.withRegistry("https://${ECR_REPO}", 'aws-credentials-id') { // Use AWS credentials for Docker registry
                        echo "Pushing Docker image to ECR"
                        dockerImage.push("${IMAGE_TAG}") // Push the Docker image with the build ID tag
                        dockerImage.push("latest") // Push the Docker image with the latest tag
                    }
                }
            }
        }

        stage('Deploy to EKS') {
            steps {
                script {
                    sh '''
                    echo "Updating kubeconfig for EKS cluster:"
                    aws eks --region ${AWS_REGION} update-kubeconfig --name my-eks-cluster // Update with your EKS cluster name

                    echo "Applying Kubernetes deployment:"
                    kubectl apply -f k8s/deployment.yaml

                    echo "Checking rollout status:"
                    kubectl rollout status deployment/my-app
                    '''
                }
            }
        }

        stage('Commit Version Update') {
            steps {
                script {
                    sh '''
                    git config user.email "snehavardhan1996@gmail.com"
                    git config user.name "Jenkins"
                    git add .
                    git commit -m "Automated version update to ${IMAGE_TAG}"
                    git push origin main
                    '''
                }
            }
        }
    }

    post {
        success {
            echo 'Pipeline completed successfully.'
        }
        failure {
            echo 'Pipeline failed. Please check the detailed logs above for more information.'
        }
    }
}
