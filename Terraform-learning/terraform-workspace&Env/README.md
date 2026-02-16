# Terraform Workspaces & Environments

This section covers managing multiple environments (dev, staging, prod) using Terraform Workspaces.

## What Are Workspaces?

Workspaces allow you to maintain **separate state files** for the same configuration. By default, every Terraform project runs in the `default` workspace. You can create additional workspaces to manage multiple environments without duplicating code.

Each workspace gets its own independent `terraform.tfstate`, so changes in `dev` do not affect `prod`.

## Managing Multi-Environments (dev, staging, prod)

### Without Workspaces (Bad Practice)

You would need separate directories for each environment, duplicating `.tf` files:

```
infra-dev/
infra-staging/
infra-prod/
```

### With Workspaces (Good Practice)

One set of `.tf` files, multiple workspaces:

```
infra/
├── main.tf
├── variables.tf
└── State files:
    ├── terraform.tfstate.d/dev/terraform.tfstate
    ├── terraform.tfstate.d/staging/terraform.tfstate
    └── terraform.tfstate.d/prod/terraform.tfstate
```

## Commands

### Creating and Switching Workspaces

List all workspaces:

```bash
terraform workspace list
```

Create a new workspace:

```bash
terraform workspace new dev
terraform workspace new staging
terraform workspace new prod
```

Switch to an existing workspace:

```bash
terraform workspace select dev
```

Show the current workspace:

```bash
terraform workspace show
```

Delete a workspace (must switch away first):

```bash
terraform workspace select default
terraform workspace delete dev
```

### Using Workspace Name in Configuration

You can reference the current workspace name in your `.tf` files using `terraform.workspace`:

```hcl
resource "aws_instance" "server" {
  instance_type = terraform.workspace == "prod" ? "t3.large" : "t3.micro"
  ami           = "ami-0317b0f0a0144b137"

  tags = {
    Name        = "${terraform.workspace}-server"
    Environment = terraform.workspace
  }
}
```

### Conditional Resource Sizing Per Environment

```hcl
# Volume size: prod = 50 GB, staging = 20 GB, dev = 10 GB
root_block_device {
  volume_size = terraform.workspace == "prod" ? 50 : (terraform.workspace == "staging" ? 20 : 10)
  volume_type = "gp3"
}
```

### Instance Count Per Environment

```hcl
resource "aws_instance" "server" {
  count = terraform.workspace == "prod" ? 3 : 1
  ...
}
```

## Typical Workflow

```bash
# 1. Create workspaces
terraform workspace new dev
terraform workspace new prod

# 2. Switch to dev and deploy
terraform workspace select dev
terraform apply

# 3. Switch to prod and deploy (separate state)
terraform workspace select prod
terraform apply

# 4. Verify current workspace
terraform workspace show
```

> **Important**: Workspaces are best for **same configuration, different state**. If dev and prod have significantly different architectures, consider separate root modules or directory-based environments instead.
