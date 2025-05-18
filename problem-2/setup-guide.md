# Setup Guide

## Introduction

This sets up a Docker registry on an EC2 instance on AWS with an S3 bucket as the storage backend. The registry is exposed through a public IP address on port 5000. The security group for the EC2 instance is set up so that only the public IP address of the person who sets it up can access it for testing. In a production environment, proper TLS and authentication needs to be set up.

## Requirements

- AWS credentials with appropriate permissions to set up the necessary infrastructure
- `docker` installed locally on the test machine

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

### Variables

The following variables are required. Create a `terraform.auto.tfvars` file and assign values to these variables.

```terraform.auto.tfvars
# the bucket that will be used as the storage backend
bucket-name    = "your-bucket-name"
# your public IP address to restrict access to the registry
my-public-ip   = "your-public-ip-address"
```

Refer to the [variables.tf](/problem-2/terraform/variables.tf) file for all the variables and their default values.

It's also possible to pass in your public SSH key as a variable for debugging purposes. Refer to the commented out code in the [variables.tf](/problem-2/terraform/variables.tf) and [registry.tf](/problem-2/terraform/registry.tf) files for more information.

## Deploy the Docker Registry

Once Terraform has been set up, run `terraform apply` to create the resources necessary for the Docker registry. Take note of the public IP address of the Docker registry in the Terraform output.

![registry public IP output](/problem-2/images/registry-public-ip-output.png)

On the AWS console, go to the EC2 instances page and wait for the instance's status to be ready.

![ec2 instance ready](/problem-2/images/ec2-instance-ready.png)

The Docker registry should be up and running now.

## Docker Setup

Since the Docker registry is set up without TLS, you need to add it as an insecure registry to perform pull and push operations.

### Linux

Add the following to the `/etc/docker/daemon.json` file.

```/etc/docker/daemon.json
{
  "insecure-registries": ["PUBLIC_IP:5000"]
}
```

### MacOS

On MacOS, you need to configure this with Docker Desktop. Open Docker Desktop and navigate to the `Settings > Docker Engine` tab, then add the following to the JSON field.

```json
{
  "insecure-registries": ["PUBLIC_IP:5000"]
}
```

![docker desktop settings](/problem-2/images/docker-desktop-settings.png)
