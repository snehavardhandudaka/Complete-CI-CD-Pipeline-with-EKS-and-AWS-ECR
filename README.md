# Complete-CI-CD-Pipeline-with-EKS-and-AWS-ECR

This project is about setting up a complete automated pipeline that takes a Java application, builds it, packages it into a Docker container, and then deploys it to a Kubernetes cluster on AWS. All of this is managed through Jenkins, which automates the entire process.

What I Built:
Private Docker Repository on AWS ECR:

I set up a private repository on AWS where the Docker images (the packaged versions of our application) are stored securely.
Automated CI/CD Pipeline with Jenkins:

The pipeline automatically:
Pulls the latest code from the Git repository.
Builds the Java application using Maven.
Packages it into a Docker image.
Pushes that image to the AWS ECR repository.
Deploys the new version of the application to a Kubernetes cluster (EKS) on AWS.
Updates the version in the Git repository to keep track of what’s deployed.
Deployment to Kubernetes (EKS):

I configured the pipeline to deploy the application to an AWS-managed Kubernetes cluster. This ensures that the latest version is always running in a scalable and secure environment.
What I Learned:
Automating the Deployment Process:

I learned how to fully automate the process of taking code, turning it into a running application, and deploying it to a cloud environment with minimal manual intervention.
Managing Docker Images with AWS ECR:

I gained experience in using AWS ECR to store and manage Docker images, including handling different versions of the application.
Working with Kubernetes on AWS:

I learned how to deploy and manage applications on a Kubernetes cluster, specifically using AWS’s EKS service. This included setting up permissions and ensuring secure access to the cluster.
Building and Configuring Jenkins Pipelines:

I improved my skills in setting up Jenkins to automate tasks, including handling builds, running tests, and deploying applications.
Importance of Automation and Version Control:

I saw firsthand how automation makes deployment faster and more reliable, and how version control helps keep everything organized and consistent.

This project is important because it shows how to use modern tools and practices to automate the entire process of getting software from code to production. It makes the deployment process faster, more reliable, and easier to manage, which is crucial for delivering high-quality software efficiently.
