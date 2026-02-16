# Lab 9: Conditional Expressions

This lab shows how to make your configuration dynamic using conditional logic. You can change resource properties based on input variables.

## Files

- **ec2.tf**: Uses a conditional expression for `volume_size`.
- **variables.tf**: Defines the `env` variable (default: `dev`) and `ec2_default_root_storage_size`.

## Key Concepts

- **Syntax**: `condition ? true_val : false_val`
- **Example**: `var.env == "prd" ? 20 : var.ec2_default_root_storage_size`
  - If `env` is "prd", volume size is 20 GB.
  - Otherwise, it defaults to the variable value (15 GB).

## Commands

Run with default (dev) environment:

```bash
terraform plan
```

_Check the planned volume size (should be 15)._

Run for production environment:

```bash
terraform plan -var="env=prd"
```

_Check the planned volume size (should be 20)._
