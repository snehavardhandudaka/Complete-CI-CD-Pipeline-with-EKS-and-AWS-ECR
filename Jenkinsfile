pipeline {
    agent any

    tools {
        maven 'Maven 3.8.7' // Name of the Maven installation in Jenkins
    }

    environment {
        AWS_REGION = 'us-east-2'
        ECR_REPO = '761018874575.dkr.ecr.us-east-2.amazonaws.com/my-java-app-repo'
        IMAGE_TAG = "${env.BUILD_ID}" // Tag for the Docker image
    }

    stages {
        stage('Checkout') {
            steps {
                git url: 'https://github.com/snehavardhandudaka/Complete-CI-CD-Pipeline-with-EKS-and-AWS-ECR.git', credentialsId: 'git-credentials-id'
            }
        }

        stage('Build Maven Project') {
            steps {
                 { // Adjust this path if your pom.xml is not at the root
                    sh 'mvn clean install'
                }
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    dockerImage = docker.build("${env.ECR_REPO}:${env.IMAGE_TAG}")
                }
            }
        }

        stage('Authenticate Docker to AWS ECR') {
            steps {
                script {
                    sh '''
                    aws ecr get-login-password --region ${AWS_REGION} | docker login --username AWS --password-stdin ${ECR_REPO}
                    '''
                }
            }
        }

        stage('Push to AWS ECR') {
            steps {
                script {
                    docker.withRegistry("https://${env.ECR_REPO}", 'jenkins_user') {
                        dockerImage.push("${env.IMAGE_TAG}")
                        dockerImage.push("latest") // Optionally push the 'latest' tag
                    }
                }
            }
        }

        stage('Deploy to EKS') {
            steps {
                script {
                    sh '''
                    aws eks --region ${AWS_REGION} update-kubeconfig --name my-eks-cluster
                    kubectl apply -f k8s/deployment.yaml
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

        stage('Verify Files') {
            steps {
                sh 'ls -la'
            }
        }
    }

    post {
        success {
            echo 'Pipeline completed successfully.'
        }
        failure {
            echo 'Pipeline failed.'
        }
    }
}
