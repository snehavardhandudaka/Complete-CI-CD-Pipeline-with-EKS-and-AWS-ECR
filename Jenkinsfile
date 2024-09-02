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
                // Checkout the code from GitHub
                git url: 'https://github.com/snehavardhandudaka/Complete-CI-CD-Pipeline-with-EKS-and-AWS-ECR.git', credentialsId: 'git-credentials-id'
                
                // Verify the directory contents
                sh 'ls -la'
            }
        }

        stage('Verify Files') {
            steps {
                // List directory contents to verify presence of pom.xml and Dockerfile
                sh 'ls -la'
            }
        }

        stage('Pre-clean Workspace') {
            steps {
                // Manually clean the target directory to avoid issues with Maven's clean phase
                sh 'rm -rf target'
            }
        }

        stage('Build Maven Project') {
            steps {
                dir('/var/lib/jenkins/workspace/java-app-pipeline/Complete-CI-CD-Pipeline-with-EKS-and-AWS-ECR') {
                    // Ensure Maven runs in the directory with the pom.xml file
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
                withCredentials([[$class: 'AmazonWebServicesCredentialsBinding', credentialsId: 'aws-credentials-id']]) {
                    script {
                        sh '''
                        # Print AWS CLI version for debugging
                        aws --version

                        # Print Docker version for debugging
                        docker --version

                        # Print the login password to verify the command
                        aws ecr get-login-password --region ${AWS_REGION} > /tmp/ecr-password.txt
                        cat /tmp/ecr-password.txt

                        # Authenticate Docker to AWS ECR
                        cat /tmp/ecr-password.txt | docker login --username AWS --password-stdin ${ECR_REPO}
                        '''
                    }
                }
            }
        }

        stage('Push to AWS ECR') {
            steps {
                script {
                    docker.withRegistry("https://${env.ECR_REPO}", 'aws-credentials-id') {
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
