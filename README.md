# Terraform Labs

This repository contains a progressive series of Terraform labs covering basics to advanced topics.

## Labs Structure

- **[lab1-provider](./lab1-provider)**: Setting up the AWS Provider (`provider.tf`).
- **[lab2-s3](./lab2-s3)**: Adding an S3 bucket resource (`s3.tf`).
- **[lab3-ec2](./lab3-ec2)**: Launching an EC2 instance with a security group and key pair (`ec2.tf`).
- **[lab4-variables-block](./lab4-variables-block)**: Using Input Variables (`variables.tf`, `ec2-var.tf`).
- **[lab5-outputs-blocks](./lab5-outputs-blocks)**: Using Output Values (`outputs.tf`, `ec2.tf`).
- **[lab6-MetaArgs-COUNT](./lab6-MetaArgs-COUNT)**: Creating multiple instances with `count` (`ec2.tf`).
- **[lab7-FOR_EACH](./lab7-FOR_EACH)**: Dynamic resource creation with `for_each` (`ec2.tf`).
- **[lab8-DEPENDS_ON](./lab8-DEPENDS_ON)**: Explicit dependency management using `depends_on` (`ec2.tf`).
- **[lab9-Conditional\_ Expressions](./lab9-Conditional_%20Expressions)**: Using conditional logic in resources (`ec2.tf`, `variables.tf`).
- **[lab10-Advanced_commands](./lab10-Advanced_commands)**: Guide to advanced commands: state manipulation, taint, import, and graph.

## How to use

Navigate to each lab directory to run the Terraform commands.

```bash
cd lab1-provider
terraform init
terraform plan
terraform apply
```

For Lab 10, follow the instructions in the `README.md` to run the advanced commands.
