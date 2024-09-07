What I Built:
I built a complete CI/CD pipeline for deploying a Java Spring Boot application on a Kubernetes (EKS) cluster using AWS services like ECR (Elastic Container Registry) and Jenkins. The pipeline automates the process of building, testing, and deploying the application to a production-like environment, ensuring seamless integration and continuous delivery.

Technologies Used:
Kubernetes (EKS): To manage and orchestrate containerized applications.
AWS ECR: For storing Docker images in a private registry.
Jenkins: For automating the CI/CD pipeline.
Docker: To containerize the Java Spring Boot application.
Java: The application backend is built using Spring Boot.
Maven: For dependency management and building the Java application.
Git: To version control the codebase.
Linux: As the underlying operating system for all services.
Key Features of the Project:
Private AWS ECR Repository: Created and integrated a private Docker repository on AWS ECR for securely storing Docker images.

Jenkins Pipeline: Configured a Jenkins pipeline with the following stages:

Checkout: Cloning the project code from a Git repository.
Build: Compiling and packaging the Java Spring Boot application using Maven.
Build Docker Image: Containerizing the application by creating a Docker image using a Dockerfile.
Push to AWS ECR: Authenticating with AWS and pushing the built Docker image to a private AWS ECR repository.
Deploy to EKS: Deploying the new Docker image to a Kubernetes (EKS) cluster, applying the changes using kubectl.
Commit Version Update: Committing the updated version information to the Git repository.
Kubernetes Deployment: Managed application deployment to the Kubernetes cluster using a deployment configuration (deployment.yaml) that specifies the application, number of replicas, and update strategy.

What I Learned:
CI/CD Automation:

Gained in-depth experience in automating the build, test, dockerize, and deployment processes using Jenkins.
Learned how to implement a multi-stage pipeline in Jenkins, with automatic rollback in case of failure.
Docker & Containerization:

Mastered containerizing Java applications with Docker.
Learned to work with AWS ECR as a private Docker registry and manage Docker image tags and versions.
Kubernetes Orchestration:

Learned how to deploy, scale, and manage applications using AWS EKS (Elastic Kubernetes Service).
Understood Kubernetes resource management with deployments, services, and rollouts.
AWS Integration:

Deepened knowledge of AWS IAM roles for securing communication between AWS services (ECR, EKS, Jenkins).
Improved understanding of AWS CLI to authenticate and interact with AWS ECR and EKS within a CI/CD pipeline.
Infrastructure as Code (IaC):

Gained experience in writing Kubernetes deployment manifests (.yaml) and integrating them into an automated pipeline.
Project Summary:
This project helped me build a fully automated, scalable, and production-ready deployment pipeline using industry-standard tools and technologies like Jenkins, Docker, and Kubernetes. It also enhanced my understanding of CI/CD practices, container orchestration, and cloud-native deployments using AWS services.
