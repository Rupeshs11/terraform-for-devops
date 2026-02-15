# Lab 8: Meta-Argument `depends_on`

This lab demonstrates explicit dependency management using `depends_on`. While Terraform automatically infers dependencies based on resource references (e.g., `vpc_id = aws_vpc.main.id`), sometimes dependencies are hidden or need to be enforced manually.

## Files

- **ec2.tf**: The `aws_instance` resource has a `depends_on` block referencing the Security Group.

## Key Concepts

- **Implicit Dependency**: Terraform knows resource A depends on B if A references B's attribute.
- **Explicit Dependency**: Use `depends_on = [ resource_type.name ]` to force Terraform to create the dependency first, even if not directly referenced. This is crucial for things like Policy attachments or timing issues.

## Commands

Initialize and Apply:

```bash
terraform init
terraform apply
```

**Note**: Ensure the configuration is valid before running. Explicit dependencies ensure the Security Group is fully created before the Instance attempts to launch.
