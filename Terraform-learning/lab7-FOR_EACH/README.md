# Lab 7: Meta-Argument `for_each`

This lab uses the `for_each` meta-argument to iterate over a map or set of strings, creating a distinct resource for each item. This is more flexible than `count` as it handles changes to the list more gracefully.

## Files

- **ec2.tf**: Uses `for_each` to iterate over a map of instance names to instance types (e.g., `knox-micro` -> `t3.micro`).
- **variables.tf**: Input variables.

## Key Concepts

- **`for_each`**: Accepts a map or set of strings.
- **`each.key`**: The map key (e.g., `knox-micro`).
- **`each.value`**: The map value (e.g., `t3.micro`).

## Commands

Initialize and Apply:

```bash
terraform init
terraform apply
```

Since a map with two keys is provided, Terraform will plan to create 2 instances.
