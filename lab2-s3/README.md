# Lab 2: S3 Bucket Creation

This lab builds upon the provider setup by adding an AWS S3 bucket resource.

## Files

- **s3.tf**: Defines an S3 bucket resource alongside the provider configuration.

## Commands

Initialize Terraform:

```bash
terraform init
```

Preview the changes to be made:

```bash
terraform plan
```

Apply the configuration to create the S3 bucket:

```bash
terraform apply
```

_Type `yes` when prompted to confirm._

To clean up resources:

```bash
terraform destroy
```
