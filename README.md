# Introduction
This project aims to provide an infrastructure setup in AWS and initialize EKS. The scope of this repository is to prepare everything up to the point where a Kubernetes cluster is ready for the deployment of workloads. It configures the AWS resources, particularly AWS EKS.

# Solution Design
The goal of this project is to provide **multi-region Kubernetes environments** for **Development (Dev), Quality Assurance (QA), and Production**, enabling **automated application deployments** based on **GitOps best practices**.  

The solution consists of four projects:  

## 1. [ops-infra](https://github.com/BrutalHex/ops-infra)  
Configures **AWS** infrastructure and initializes **Amazon EKS (Elastic Kubernetes Service)**.  

## 2. [ops-kubernetes-base](https://github.com/BrutalHex/ops-kubernetes-base)  
Sets up essential workloads in **EKS**, including **ArgoCD**, **Cert-Manager**, and other foundational components.  

## 3. [ops-argocd-apps](https://github.com/BrutalHex/ops-argocd-apps)  
Hosts **YAML definitions** that describe Kubernetes workloads in the form of **ArgoCD Applications**.  

## 4. [ops-vectordb](https://github.com/BrutalHex/ops-vectordb)  
A sample vector databse packaged as a **[Helm Chart](https://brutalhex.github.io/ops-vectordb/)**.  


## Prerequisites
- An **AWS account** with privileges to create and manage:  
  - VPC  
  - Subnets
  - EC2 instances
  - Node groups
  - EKS (Elastic Kubernetes Service)
  - Load Balancers 
  - Route 53 (DNS management)


# Project Workflow Overview  

The workflow that achieves the project's goal consists of the following steps:  

## 1. AWS Infrastructure Setup (`ops-infra`)
In **[ops-infra](https://github.com/BrutalHex/ops-infra)**, the **[cluster-setup](https://github.com/BrutalHex/ops-infra/blob/663565181300aae69fb48f455685a73fe2ce53b1/.github/workflows/cluster-setup.yaml)** pipeline is executed to configure **AWS**:  
  - Configures **VPC** and multi-AZ **subnets**  
  - Configures **Route 53**  
  - Configures **Cloudflare** DNS records for subdomain.
  - Configures **EKS (Elastic Kubernetes Service)**  
  - Configures **IAM roles and policies**  
  - Configures **AWS Secrets** to store cluster information
  - Updates the variable for **AWS secret** in [ops-kubernetes-base](https://github.com/BrutalHex/ops-kubernetes-base)

## 2. Kubernetes Base Setup (`ops-kubernetes-base`)
In **[ops-kubernetes-base](https://github.com/BrutalHex/ops-kubernetes-base)**, the **[setup](https://github.com/BrutalHex/ops-kubernetes-base/blob/538720d6fae787a9ece50111a70e106af632707f/.github/workflows/setup.yaml)** pipeline is executed to deploy the required workloads, including **Istio Service Mesh**, **Keycloak*** ,**ArgoCD**, into **EKS** and configure **ApplicationSet**. It sets up:  
  - **Cert-Manager**  
  - **External-DNS**  
  - **mTLS**
  - **OIDC Authentication**
  - **Authorization And (Network policies both level 4 and level 7)**

## 3. Application Packaging & Deployment  
-  DB(any app) gets deployed as **Helm charts** and gets pushed into a [Helm repository](https://brutalhex.github.io/ops-vectordb/).  
- For each application, an ArgoCD application manifest (`argocd-<app-name>.yaml`) is created in **[ops-argocd-apps](https://github.com/BrutalHex/ops-argocd-apps)**.  
- **ArgoCD** watches and pulls the application YAML files from `ops-argocd-apps` that match the `argocd-*.yaml` pattern.  
- The ApplicationSet in **ArgoCD** applies templating and regenerates the `Application` object in the `argocd` namespace.  
- ArgoCD monitors the **Helm repository** for each application and pulls the latest version.  
- ArgoCD deploys and updates Helm charts for applications in the Kubernetes cluster.  

This setup ensures a fully automated, scalable, and GitOps-driven Kubernetes deployment workflow.



## Features
- Multi-region, Multi-AZ deployment of Kubernetes clusters (High Availability & Resiliency)  
- Dynamic OIDC-based Authentication and Authorization
- Deployment of precise IAM roles and policies
- Provision of Load Balancer for traffic management  
- Automated Route 53 management
- Automated application deployment using **ArgoCD**  
- Secure wildcard certificate management using **Let's Encrypt** and **Cert-Manager**  
- Setup of EKS Autoscaler
- Secure mTLS setup.



## Road Ahead
The road ahead is defined based on the entire solution design and consists of items that might not be directly related to the project in this repository.  

- Deploy HashiCorp Vault 

- Deploy Image Updater into EKS  
- Add branching strategies in Git repositories:  
  - Pull requests  
  - Release pipeline  
  - Linters  
  - sonarQube
  - Dependable bot
  - JFROG Xray

# Code Structure
```plaintext
└── infra: it has the terraform definitions to build the infrastructure
    └── modules
        ├── eks: this module is responsible for generating the AWS resources like EKS and Node groups,...
```
