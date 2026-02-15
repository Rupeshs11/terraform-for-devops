# Lab 6: Meta-Argument Count

This lab introduces the `count` meta-argument, allowing you to create multiple identical instances of a resource without duplicating code.

## Files

- **ec2.tf**: Uses `count = 3` inside the `aws_instance` resource to create three instances.
- **install_nginx.sh**: A script passed to `user_data` to configure the instance on boot.

## Key Concepts

- **Count**: `count = N` creates N copies of the resource.
- **User Data**: Passing a shell script (`file("install_nginx.sh")`) to bootstrap the instance.

## Commands

Initialize and Apply:

```bash
terraform init
terraform apply
```

Terraform will indicate that it plans to create 3 instances (e.g., `Plan: 3 to add`).
