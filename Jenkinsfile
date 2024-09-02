pipeline {
    agent any

    environment {
        AWS_REGION = 'us-east-2'
        ECR_REPO = '761018874575.dkr.ecr.us-east-2.amazonaws.com/my-java-app-repo'
    }

    stages {
        stage('Checkout SCM') {
            steps {
                git url: 'https://github.com/snehavardhandudaka/Complete-CI-CD-Pipeline-with-EKS-and-AWS-ECR.git'
            }
        }

        stage('Authenticate Docker to AWS ECR') {
            steps {
                withCredentials([[$class: 'AmazonWebServicesCredentialsBinding', credentialsId: 'aws-credentials-id']]) {
                    script {
                        try {
                            // Debug output
                            sh 'aws --version'
                            sh 'aws sts get-caller-identity'

                            // Authenticate Docker
                            sh '''
                            echo "Attempting to authenticate Docker to AWS ECR..."
                            aws ecr get-login-password --region ${AWS_REGION} | docker login --username AWS --password-stdin ${ECR_REPO}
                            '''
                            
                            echo "Docker login succeeded."
                        } catch (Exception e) {
                            echo "Docker login failed: ${e.message}"
                            currentBuild.result = 'FAILURE'
                            throw e
                        }
                    }
                }
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    try {
                        echo "Building Docker image..."
                        sh 'docker build -t my-java-app-repo:latest .'
                        echo "Docker image build succeeded."
                    } catch (Exception e) {
                        echo "Docker image build failed: ${e.message}"
                        currentBuild.result = 'FAILURE'
                        throw e
                    }
                }
            }
        }

        stage('Push Docker Image to ECR') {
            steps {
                script {
                    try {
                        echo "Pushing Docker image to AWS ECR..."
                        sh 'docker tag my-java-app-repo:latest ${ECR_REPO}:latest'
                        sh 'docker push ${ECR_REPO}:latest'
                        echo "Docker image push succeeded."
                    } catch (Exception e) {
                        echo "Docker image push failed: ${e.message}"
                        currentBuild.result = 'FAILURE'
                        throw e
                    }
                }
            }
        }
    }
}
