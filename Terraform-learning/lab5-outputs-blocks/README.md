# Lab 5: Output Values

This lab focuses on using Output Values to return information about your infrastructure after deployment, such as IP addresses or DNS names.

## Files

- **outputs.tf**: Defines `output` blocks to expose resource attributes.
- **ec2.tf**: Standard EC2 deployment.

## Key Concepts

- **Output Blocks**: Use `output "name" { value = ... }` to print data.
- **Attribute Reference**: referencing attributes exported by resources (e.g., `aws_instance.my-ec2.public_ip`).

## Commands

Apply the configuration:

```bash
terraform apply
```

After applying, the outputs will be displayed in the terminal. You can also query them later:

```bash
terraform output
```

To get a specific output:

```bash
terraform output ec2_public_ip
```
