pipeline {
    agent any

    tools {
        maven 'Maven 3.8.7'
    }

    environment {
        AWS_REGION = 'us-east-2'
        ECR_REPO = '761018874575.dkr.ecr.us-east-2.amazonaws.com/my-java-app-repo'
        IMAGE_TAG = "${env.BUILD_ID}"
    }

    stages {
        stage('Checkout') {
            steps {
                git url: 'https://github.com/snehavardhandudaka/Complete-CI-CD-Pipeline-with-EKS-and-AWS-ECR.git', credentialsId: 'git-credentials-id'
                sh 'ls -la'
            }
        }

        // Other stages...

        stage('Build Docker Image') {
            steps {
                script {
                    dockerImage = docker.build("${ECR_REPO}:${IMAGE_TAG}", 'Complete-CI-CD-Pipeline-with-EKS-and-AWS-ECR')
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
                    docker tag ${ECR_REPO}:${IMAGE_TAG} ${ECR_REPO}:${IMAGE_TAG}
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

                        echo "Applying Kubernetes deployment:"
                        kubectl apply -f k8s/deployment.yaml

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
            // Add notification step here
        }
        failure {
            echo 'Pipeline failed. Please check the detailed logs above for more information.'
            // Add notification step here
        }
    }
}
