# Lab 11: VPC Using Terraform Module

This lab demonstrates how to create a custom VPC using the official **terraform-aws-modules/vpc/aws** module from the Terraform Registry, instead of defining every resource manually.

## What is a VPC?

A Virtual Private Cloud (VPC) is your own isolated network in AWS. It lets you control IP ranges, subnets, route tables, and gateways. Without a VPC, your resources run in the default network with limited control.

## Files

- **vpc.tf**: Calls the official VPC module and configures it.
- **variables.tf**: Defines the `env` variable used for environment tagging.

## Key Concepts

### Using a Registry Module

Instead of writing dozens of resources manually, you use a pre-built module:

```hcl
module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = "custom-vpc"
  cidr = "10.0.0.0/16"

  azs             = ["ap-south-1a", "ap-south-1b"]
  private_subnets = ["10.0.1.0/24", "10.0.2.0/24"]
  public_subnets  = ["10.0.101.0/24", "10.0.102.0/24"]

  enable_nat_gateway = true
  enable_vpn_gateway = true

  tags = {
    Terraform   = "true"
    Environment = var.env
  }
}
```

### What This Creates

| Resource            | Details                                  |
| ------------------- | ---------------------------------------- |
| **VPC**             | CIDR `10.0.0.0/16`                       |
| **Public Subnets**  | `10.0.101.0/24`, `10.0.102.0/24` (2 AZs) |
| **Private Subnets** | `10.0.1.0/24`, `10.0.2.0/24` (2 AZs)     |
| **NAT Gateway**     | Allows private subnet internet access    |
| **VPN Gateway**     | For VPN connectivity                     |

### CIDR Breakdown

- `10.0.0.0/16` → 65,536 IPs total.
- `/24` subnets → 256 IPs each.
- **Public subnets** get an Internet Gateway (direct internet access).
- **Private subnets** route traffic through the NAT Gateway.

## Commands

Initialize (downloads the VPC module):

```bash
terraform init
```

Preview the resources to be created:

```bash
terraform plan
```

Apply the configuration:

```bash
terraform apply
```

Destroy all VPC resources:

```bash
terraform destroy
```

> **Note**: NAT Gateways cost money even when idle. Always run `terraform destroy` when done to avoid charges.
