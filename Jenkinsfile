pipeline {
    agent any

    tools {
        maven 'Maven'
    }

    environment {
        AWS_REGION = 'us-east-2'
        ECR_REPO = '761018874575.dkr.ecr.us-east-2.amazonaws.com/my-java-app-repo'
        IMAGE_TAG = "${env.BUILD_ID}"
        DOCKER_BUILDKIT = '1' // Enable BuildKit
    }

    stages {
        stage('Checkout') {
            steps {
                git url: 'https://github.com/snehavardhandudaka/Complete-CI-CD-Pipeline-with-EKS-and-AWS-ECR.git', credentialsId: 'snehavardhandudaka'
                sh 'pwd'  // Print working directory
                sh 'ls -al' // List files to ensure Dockerfile and k8s directory are present
            }
        }

        stage('Build') {
            steps {
                dir('my-java-app') {
                    sh 'mvn clean install'
                }
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    // Ensure Dockerfile is in the 'my-java-app' directory
                    sh 'ls -l my-java-app'  // Verify Dockerfile location
                    sh 'cat my-java-app/Dockerfile'  // Print Dockerfile content

                    // Build Docker image with correct path to Dockerfile and context
                    dockerImage = docker.build("${ECR_REPO}:${IMAGE_TAG}", '-f my-java-app/Dockerfile my-java-app')
                    echo "Built Docker image: ${ECR_REPO}:${IMAGE_TAG}"
                }
            }
        }

        stage('Authenticate Docker to AWS ECR') {
            steps {
                withCredentials([[$class: 'AmazonWebServicesCredentialsBinding', credentialsId: 'AWS Credentials']]) {
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
                    sh '''
                    echo "Tagging Docker image:"
                    docker tag ${ECR_REPO}:${IMAGE_TAG} ${ECR_REPO}:latest

                    echo "Pushing Docker image to ECR:"
                    docker push ${ECR_REPO}:${IMAGE_TAG}
                    docker push ${ECR_REPO}:latest
                    '''
                }
            }
        }

        stage('Deploy to EKS') {
            steps {
                withCredentials([[$class: 'AmazonWebServicesCredentialsBinding', credentialsId: 'AWS Credentials']]) {
                    script {
                        sh '''
                        set -e
                        echo "Updating kubeconfig for EKS cluster:"
                        aws eks --region ${AWS_REGION} update-kubeconfig --name my-eks-cluster

                        echo "Current working directory:"
                        pwd

                        echo "Listing files in k8s directory:"
                        ls -al my-java-app/k8s

                        echo "Applying Kubernetes deployment:"
                        kubectl apply -f my-java-app/k8s/deployment.yaml

                        echo "Checking rollout status:"
                        kubectl rollout status deployment/my-app
                        '''
                    }
                }
            }
        }

        stage('Commit Version Update') {
            steps {
                script {
                    sh '''
                    git config user.email "snehavardhan1996@gmail.com"
                    git config user.name "snehavardhandudaka"
                    git add .
                    git commit -m "Automated version update to ${IMAGE_TAG}" || echo "No changes to commit"
                    git push origin main || echo "Failed to push changes to origin"
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
