# Lab 3: EC2 Instance Deployment

This lab deploys an EC2 instance with a custom Security Group and Key Pair. It demonstrates dealing with dependencies and networking components.

## Files

- **ec2.tf**: Contains the EC2 instance, Security Group, VPC, and Key Pair configurations.
- **tera-key.pem.pub**: The public key file used for the Key Pair resource.

## Commands

Initialize Terraform:

```bash
terraform init
```

Preview the deployment plan:

```bash
terraform plan
```

Deploy the infrastructure:

```bash
terraform apply
```

_Type `yes` when prompted._

To remove all resources:

```bash
terraform destroy
```
