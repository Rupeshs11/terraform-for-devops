# Lab 4: Variables

This lab demonstrates how to use input variables to parameterize your Terraform configurations, making them more reusable and flexible.

## files

- **variables.tf**: Defines the input variables (`ec2_instance_type`, `aws_root_storage_size`, `ec2_ami_id`) including their type and default values.
- **ec2-var.tf**: references these variables using the `var.<variable_name>` syntax (e.g., `var.ec2_instance_type`).

## Key Concepts

- **Input Variables**: defined using the `variable` block.
- **Type Constraints**: ensuring variables are of a specific type (string, number, etc.).
- **Default Values**: providing a fallback if no value is passed.

## Commands

Initialize Terraform:

```bash
terraform init
```

Plan with default values:

```bash
terraform plan
```

Plan with custom variable values passed via CLI:

```bash
terraform plan -var="ec2_instance_type=t3.small"
```
