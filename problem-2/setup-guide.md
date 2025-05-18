# Setup Guide

## Requirements

## Terraform Setup

### Local Backend

If using a local backend, comment out the [backend.tf](/problem-2/terraform/backend.tf) file. You can then initialize Terraform with just `terraform init`.

### S3 Backend

If using S3 backend, create a backend config file that has the following content.

```backend-config.conf
bucket = "bucket-name"
key    = "key/to/state/file"
region = "region"
```

Then, initialize Terraform as followed.

```bash
terraform init -backend-config=PATH_TO_BACKEND_CONFIG_FILE
```
