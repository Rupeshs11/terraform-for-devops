# Remote Backend Infrastructure

This section sets up the required AWS infrastructure for a **Terraform Remote Backend** using S3 and DynamoDB. By default, Terraform stores state locally in `terraform.tfstate`. A remote backend stores this state in S3 and uses DynamoDB for state locking to prevent concurrent modifications.

## Why Remote Backend?

| Feature                | Local State        | Remote State (S3)           |
| ---------------------- | ------------------ | --------------------------- |
| **Team Collaboration** | Not possible       | Multiple users share state  |
| **State Locking**      | No locking         | DynamoDB prevents conflicts |
| **Versioning**         | Manual backups     | S3 versioning enabled       |
| **Security**           | Local file on disk | Encrypted in S3             |

## Files

- **s3.tf**: Creates the S3 bucket to store the state file.
- **dynamodb.tf**: Creates the DynamoDB table for state locking.
- **provider.tf**: AWS provider configuration.
- **terraform.tf**: Required providers block.

## Code Walkthrough

### S3 Bucket for State Storage (`s3.tf`)

```hcl
resource "aws_s3_bucket" "remote-bucket" {
  bucket = "knox-bucks-0088"

  tags = {
    Name = "knox-bucks-0088"
  }
}
```

### DynamoDB Table for State Locking (`dynamodb.tf`)

```hcl
resource "aws_dynamodb_table" "basic-dynamodb-table" {
  name           = "my-dynamodb-state-table"
  billing_mode   = "PROVISIONED"
  read_capacity  = 20
  write_capacity = 20
  hash_key       = "UserId"
  range_key      = "GameTitle"

  attribute {
    name = "UserId"
    type = "S"
  }

  tags = {
    Name        = "my-dynamodb-table"
    Environment = "production"
  }
}
```

## How to Use This Backend

### Step 1: Deploy This Infrastructure First

```bash
cd Remote-infra
terraform init
terraform apply
```

### Step 2: Configure Backend in Your Main Project

After the S3 bucket and DynamoDB table exist, add this `backend` block to your project's `terraform.tf`:

```hcl
terraform {
  backend "s3" {
    bucket         = "knox-bucks-0088"
    key            = "terraform.tfstate"
    region         = "ap-south-1"
    dynamodb_table = "my-dynamodb-state-table"
    encrypt        = true
  }
}
```

### Step 3: Migrate Local State to Remote

```bash
terraform init
```

Terraform will detect the backend change and ask:

> _Do you want to copy existing state to the new backend?_

Type `yes` to migrate.

## Commands

Check current state backend:

```bash
terraform state pull
```

Force unlock state (if locked due to a crash):

```bash
terraform force-unlock <LOCK_ID>
```
