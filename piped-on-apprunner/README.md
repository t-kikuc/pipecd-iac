# Running a piped on AWS App Runner

## Overview

<img src="./diagram/architecture.png">

- **NOTE: The version of piped must be >=v0.46.0-rc0 because https://github.com/pipe-cd/pipecd/pull/4785 is required.**
- If you want to deploy apps to ECS, you need to attach an additional policy to the IAM Role. See [iam.tf](./terraform/iam.tf).

## Usage > by Terraform

1. Create your .tfvars file. All required variables are defined in [variables.tf](./terraform/variables.tf).
2. Deploy 
    ```bash
    cd ./terraform 
    sh ./apply.sh <YOUR_TFVARS_FILE_PATH>
    ```
