# Lab 10: Advanced Terraform Commands

This section covers advanced state management and diagnostic commands essential for maintaining Terraform infrastructure in production.

## 1. State Manipulation (`terraform state`)

Terraform stores the mapping between your code and real-world resources in a state file (`terraform.tfstate`). You sometimes need to modify this state file manually.

### Commands

- **List resources in state**:
  ```bash
  terraform state list
  ```
- **Show details of a resource**:
  ```bash
  terraform state show aws_instance.my-ec2
  ```
- **Move a resource** (rename in state without destroying/recreating):
  ```bash
  terraform state mv aws_instance.old_name aws_instance.new_name
  ```
- **Remove a resource from state** (stop tracking it without destroying it):
  ```bash
  terraform state rm aws_instance.my-ec2
  ```

## 2. Taint (`terraform taint` / `-replace`)

If a resource is corrupted or you want to force its recreation during the next apply, you can "taint" it.

### Commands

Mark a resource as tainted:

```bash
terraform taint aws_instance.my-ec2
```

_The next `terraform apply` will destroy and recreate this instance._

**Modern Alternative (Terraform v0.15+)**:
Instead of tainting state, you can use the `-replace` flag with apply:

```bash
terraform apply -replace="aws_instance.my-ec2"
```

## 3. Import (`terraform import`)

If you have existing infrastructure created manually (e.g., via AWS Console) and want to bring it under Terraform management.

### Workflow

1.  Define the `resource` block in your `.tf` file (initially empty or matching the real resource).
2.  Run the import command mapping the Terraform address to the AWS ID.

### Command

```bash
terraform import aws_instance.my-ec2 i-1234567890abcdef0
```

_After importing, run `terraform plan` to see if your code matches the imported state._

## 4. Graph (`terraform graph`)

Visualizes the dependency graph of your configuration.

### Command

Output the graph in DOT format:

```bash
terraform graph
```

To visualize it (requires Graphviz installed):

```bash
terraform graph | dot -Tsvg > graph.svg
```
