# Pair Programming Exercise with Terraform

This repository contains the code and instructions for a pair programming exercise using Terraform. The goal of this exercise is to deploy a small EKS cluster on AWS and deploy a TypeScript app to the EKS cluster.

## Prerequisites

Before starting the exercise, make sure you have the following prerequisites installed:

- Terraform: [Installation Guide](https://learn.hashicorp.com/tutorials/terraform/install-cli)
- AWS CLI: [Installation Guide](https://docs.aws.amazon.com/cli/latest/userguide/cli-configure-quickstart.html)
- kubectl: [Installation Guide](https://kubernetes.io/docs/tasks/tools/install-kubectl/)

## Instructions

1. Clone this repository to your local machine:

  ```shell
  git clone <repository-url>
  ```

2. Change into the project directory:

  ```shell
  cd <repository-directory>
  ```

3. Initialize Terraform:

  ```shell
  terraform init
  ```

4. Configure your AWS credentials:

  ```shell
  aws configure
  ```

5. Deploy the EKS cluster:

  ```shell
  terraform apply
  ```

6. Configure `kubectl` to connect to the EKS cluster:

  ```shell
  aws eks --region <region> update-kubeconfig --name <cluster-name>
  ```

7. Deploy the TypeScript app to the EKS cluster:

  ```shell
  kubectl apply -f app.yaml
  ```

8. Verify that the app is running:

  ```shell
  kubectl get pods
  ```

## Cleanup

To clean up the resources created by this exercise, run the following command:
