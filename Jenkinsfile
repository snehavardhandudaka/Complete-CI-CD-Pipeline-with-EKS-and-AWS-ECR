pipeline {
    agent any

    environment {
        AWS_REGION = 'us-east-2'
        ECR_REPO = '761018874575.dkr.ecr.us-east-2.amazonaws.com/my-java-app-repo'
        IMAGE_TAG = "${env.BUILD_ID}" // Tag for the Docker image
    }

    stages {
        stage('Checkout') {
            steps {
                // Checkout the code from Git repository
                git url: 'https://github.com/snehavardhandudaka/Complete-CI-CD-Pipeline-with-EKS-and-AWS-ECR.git', credentialsId: 'git-credentials-id'
            }
        }

        stage('Build Maven Project') {
            steps {


                dir('pom.xml') {  // Change to the directory containing pom.xml
                    sh 'mvn clean package'
                }

            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    // Build Docker image with a tag
                    dockerImage = docker.build("${env.ECR_REPO}:${env.IMAGE_TAG}")
                }
            }
        }

        stage('Push to AWS ECR') {
            steps {
                script {
                    // Authenticate with AWS ECR and push the Docker image
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
                    // Configure kubectl to use the EKS cluster
                    sh '''
                    aws eks --region ${AWS_REGION} update-kubeconfig --name my-eks-cluster
<<<<<<< HEAD
                    '''

                    // Apply the deployment.yaml to the EKS cluster
                    sh '''
=======
>>>>>>> cdbc584 (add)
                    kubectl apply -f k8s/deployment.yaml
                    kubectl rollout status deployment/my-app
                    '''
                }
            }
        }

        stage('Commit Version Update') {
            steps {
                script {
                    // Commit version updates to the Git repository
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

