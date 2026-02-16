# Lab 1: Terraform Provider Setup

This lab demonstrates how to configure the AWS provider in Terraform. This is the foundational step for interacting with AWS services.

## Files

- **provider.tf**: Contains the `provider "aws"` block specifying the region.

## Commands

Initialize Terraform to download the necessary provider plugins:

```bash
terraform init
```

Format the code (optional but recommended):

```bash
terraform fmt
```

Validate the configuration:

```bash
terraform validate
```
