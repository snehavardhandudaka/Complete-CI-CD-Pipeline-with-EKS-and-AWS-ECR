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

        stage('Verify Files') {
            steps {
                sh 'ls -la'
            }
        }

        stage('Pre-clean Workspace') {
            steps {
                sh 'rm -rf target'
            }
        }

        stage('Build Maven Project') {
            steps {
                dir('/var/lib/jenkins/workspace/java-app-pipeline/Complete-CI-CD-Pipeline-with-EKS-and-AWS-ECR') {
                    sh 'mvn clean install'
                }
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    dockerImage = docker.build("${env.ECR_REPO}:${env.IMAGE_TAG}", "/var/lib/jenkins/workspace/java-app-pipeline/Complete-CI-CD-Pipeline-with-EKS-and-AWS-ECR")
                }
            }
        }

        stage('Authenticate Docker to AWS ECR') {
            steps {
                withCredentials([[$class: 'AmazonWebServicesCredentialsBinding', credentialsId: 'AWS Credentials']]) {
                    script {
                        sh '''
                        echo "AWS CLI version:"
                        aws --version

                        echo "Docker version:"
                        docker --version

                        echo "Fetching ECR login password:"
                        PASSWORD=$(aws ecr get-login-password --region ${AWS_REGION})

                        echo "Docker login with ECR:"
                        echo $PASSWORD | docker login --username AWS --password-stdin ${ECR_REPO}
                        '''
                    }
                }
            }
        }

        stage('Push to AWS ECR') {
            steps {
                script {
                    docker.withRegistry("https://${env.ECR_REPO}", 'aws-credentials-id') {
                        echo "Pushing Docker image to ECR"
                        dockerImage.push("${env.IMAGE_TAG}")
                        dockerImage.push("latest")
                    }
                }
            }
        }

        stage('Deploy to EKS') {
            steps {
                script {
                    sh '''
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

        stage('Commit Version Update') {
            steps {
                script {
                    sh '''
                    git config user.email "jenkins@example.com"
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
