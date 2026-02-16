# Terraform for DevOps

A hands-on, progressive Terraform learning path — from setting up a provider to managing multi-environment infrastructure with custom modules and remote backends.

## Labs

| Lab                                                           | Topic          | Key Concept                              |
| ------------------------------------------------------------- | -------------- | ---------------------------------------- |
| [Lab 1](./Terraform-learning/lab1-provider)                   | Provider Setup | Configuring the AWS provider             |
| [Lab 2](./Terraform-learning/lab2-s3)                         | S3 Bucket      | Creating your first resource             |
| [Lab 3](./Terraform-learning/lab3-ec2)                        | EC2 Instance   | Key Pair, Security Group, VPC            |
| [Lab 4](./Terraform-learning/lab4-variables-block)            | Variables      | Input variables and types                |
| [Lab 5](./Terraform-learning/lab5-outputs-blocks)             | Outputs        | Exposing resource attributes             |
| [Lab 6](./Terraform-learning/lab6-MetaArgs-COUNT)             | `count`        | Creating multiple instances              |
| [Lab 7](./Terraform-learning/lab7-FOR_EACH)                   | `for_each`     | Dynamic resource creation using maps     |
| [Lab 8](./Terraform-learning/lab8-DEPENDS_ON)                 | `depends_on`   | Explicit dependency management           |
| [Lab 9](./Terraform-learning/lab9-Conditional_%20Expressions) | Conditionals   | Ternary expressions in resources         |
| [Lab 10](./Terraform-learning/lab10-Advanced_commands)        | Advanced CLI   | State manipulation, taint, import, graph |
| [Lab 11](./Terraform-learning/lab11-VPC)                      | VPC Module     | Using registry modules for networking    |

## Beyond Labs

| Section                                                          | Description                                                                 |
| ---------------------------------------------------------------- | --------------------------------------------------------------------------- |
| [Terraform Modules](./Terraform-learning/terraform-modules)      | Concepts guide — registry modules, custom module structure & best practices |
| [Custom Modules](./Terraform-learning/Custom_Modules)            | Hands-on reusable module for multi-environment infra (dev/staging/prod)     |
| [Remote Backend](./Terraform-learning/Remote-infra)              | Setting up S3 + DynamoDB for remote state storage & locking                 |
| [Workspaces & Env](./Terraform-learning/terraform-workspace&Env) | Managing multiple environments using Terraform Workspaces                   |

## Prerequisites

- [Terraform](https://developer.hashicorp.com/terraform/downloads) installed
- [AWS CLI](https://aws.amazon.com/cli/) configured with valid credentials
- An AWS account with appropriate permissions

## Quick Start

```bash
cd Terraform-learning/lab1-provider
terraform init
terraform plan
terraform apply
```

Each lab folder contains its own `README.md` with detailed explanations and commands.
