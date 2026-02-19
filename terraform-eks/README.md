# Terraform EKS — AWS Kubernetes Cluster

This project provisions a production-ready **Amazon EKS (Elastic Kubernetes Service)** cluster along with its underlying VPC networking — all managed through Terraform using official AWS modules.

## Architecture Overview

```
┌─────────────────────────────────────────────────────┐
│                    AWS Cloud                        │
│                                                     │
│  ┌──────────────── VPC (10.0.0.0/16) ────────────┐  │
│  │                                                │  │
│  │  Public Subnets        Private Subnets         │  │
│  │  10.0.101.0/24         10.0.1.0/24             │  │
│  │  10.0.102.0/24         10.0.2.0/24             │  │
│  │       │                     │                  │  │
│  │       │              ┌──────┴──────┐           │  │
│  │   NAT Gateway        │  EKS Nodes  │           │  │
│  │                      │  (t2.small) │           │  │
│  │                      │  SPOT x 2-3 │           │  │
│  │                      └──────┬──────┘           │  │
│  │                             │                  │  │
│  │  Intra Subnets (Control Plane)                 │  │
│  │  10.0.5.0/24 │ 10.0.6.0/24                    │  │
│  │              │                                 │  │
│  │       ┌──────┴──────┐                          │  │
│  │       │ EKS Control │                          │  │
│  │       │    Plane    │                          │  │
│  │       └─────────────┘                          │  │
│  └────────────────────────────────────────────────┘  │
└─────────────────────────────────────────────────────┘
```

## Files Explained

### `terraform.tf` — Provider Requirements

Declares the required AWS provider version:

```hcl
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
}
```

---

### `provider.tf` — AWS Provider

Configures the AWS region using a local variable:

```hcl
provider "aws" {
  region = local.region
}
```

---

### `variable.tf` — Local Variables

All configuration values are centralized using `locals`, making them easy to modify:

```hcl
locals {
  region          = "ap-south-1"
  name            = "knox-eks-cluster"
  vpc_cidr        = "10.0.0.0/16"
  azs             = ["ap-south-1a", "ap-south-1b"]
  private_subnets = ["10.0.1.0/24", "10.0.2.0/24"]
  public_subnets  = ["10.0.101.0/24", "10.0.102.0/24"]
  intra_subnets   = ["10.0.5.0/24", "10.0.6.0/24"]
  env             = "dev"
}
```

| Variable          | Purpose                                    |
| ----------------- | ------------------------------------------ |
| `region`          | AWS region for all resources               |
| `name`            | Cluster name (used in EKS + VPC naming)    |
| `vpc_cidr`        | VPC CIDR block (65,536 IPs)                |
| `azs`             | Availability Zones for high availability   |
| `private_subnets` | Worker nodes run here (no direct internet) |
| `public_subnets`  | Load balancers, NAT Gateway                |
| `intra_subnets`   | EKS control plane communication (isolated) |
| `env`             | Environment tag (dev/staging/prod)         |

---

### `vpc.tf` — VPC Module

Creates the networking layer using the official [terraform-aws-modules/vpc](https://registry.terraform.io/modules/terraform-aws-modules/vpc/aws) module:

```hcl
module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = "${local.name}-vpc"
  cidr = local.vpc_cidr

  azs             = local.azs
  private_subnets = local.private_subnets
  public_subnets  = local.public_subnets
  intra_subnets   = local.intra_subnets

  enable_nat_gateway = true
  enable_vpn_gateway = true

  tags = {
    Terraform   = "true"
    Environment = local.env
  }
}
```

**Why 3 subnet types?**

- **Public**: Internet-facing resources (ALB, NAT Gateway)
- **Private**: Worker nodes (access internet via NAT for pulling images)
- **Intra**: Completely isolated — used for EKS control plane networking (no internet access at all)

---

### `eks.tf` — EKS Cluster

The core file — creates the EKS cluster and managed node group using the official [terraform-aws-modules/eks](https://registry.terraform.io/modules/terraform-aws-modules/eks/aws) module:

```hcl
module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 21.0"

  # Cluster Configuration
  name                   = local.name
  kubernetes_version     = "1.29"
  endpoint_public_access = true

  # Networking
  vpc_id                   = module.vpc.vpc_id
  subnet_ids               = module.vpc.private_subnets
  control_plane_subnet_ids = module.vpc.intra_subnets

  # EKS Add-ons
  addons = {
    vpc-cni    = { most_recent = true }
    kube-proxy = { most_recent = true }
    core-dns   = { most_recent = true }
  }

  # Worker Nodes
  eks_managed_node_groups = {
    knox-cluster-ng = {
      instance_types = ["t2.small"]
      min_size       = 2
      max_size       = 3
      desired_size   = 2
      capacity_type  = "SPOT"
    }
  }

  tags = {
    Environment = local.env
    Terraform   = "true"
  }
}
```

**Key decisions explained:**

| Config                      | Value  | Why                                                    |
| --------------------------- | ------ | ------------------------------------------------------ |
| `kubernetes_version`        | `1.29` | Specific K8s version for stability                     |
| `endpoint_public_access`    | `true` | Allows `kubectl` access from your machine              |
| `capacity_type`             | `SPOT` | ~60-90% cheaper than On-Demand (good for dev/learning) |
| `min_size` / `desired_size` | `2`    | Minimum 2 nodes for high availability                  |
| `max_size`                  | `3`    | Allows autoscaling up to 3 nodes under load            |

**EKS Add-ons:**
| Add-on | Purpose |
|--------|---------|
| `vpc-cni` | Assigns VPC IPs to pods (native AWS networking) |
| `kube-proxy` | Manages network rules for Service routing |
| `core-dns` | Provides DNS resolution inside the cluster |

## Commands

### Deploy the Cluster

```bash
# Initialize Terraform (downloads EKS + VPC modules)
terraform init

# Preview what will be created
terraform plan

# Deploy — this takes ~15-20 minutes
terraform apply
```

### Configure kubectl

After the cluster is created, update your kubeconfig to connect:

```bash
aws eks update-kubeconfig --name knox-eks-cluster --region ap-south-1
```

### Verify the Cluster

```bash
# Check cluster info
kubectl cluster-info

# List all nodes
kubectl get nodes

# Check running system pods
kubectl get pods -n kube-system
```

### Deploy a Test Application

```bash
# Create a simple nginx deployment
kubectl create deployment nginx --image=nginx --replicas=2

# Expose it as a LoadBalancer service
kubectl expose deployment nginx --port=80 --type=LoadBalancer

# Get the external URL
kubectl get svc nginx
```

### Destroy the Cluster

```bash
# Remove all Kubernetes resources first (important for ALB/ELB cleanup)
kubectl delete svc --all
kubectl delete deployment --all

# Destroy all Terraform resources — takes ~10-15 minutes
terraform destroy
```

> **⚠️ Cost Warning**: EKS charges $0.10/hour for the control plane + EC2 instance costs. Always run `terraform destroy` when done to avoid unexpected charges. SPOT instances help reduce cost but can be reclaimed by AWS with 2 minutes notice.

## Prerequisites

- [Terraform](https://developer.hashicorp.com/terraform/downloads) installed
- [AWS CLI](https://aws.amazon.com/cli/) configured (`aws configure`)
- [kubectl](https://kubernetes.io/docs/tasks/tools/) installed
- AWS account with permissions for EKS, EC2, VPC, and IAM
