# Setup Guide

- [Introduction](#introduction)
- [Requirements](#requirements)
- [Terraform Setup](#terraform-setup)
  - [Local Backend](#local-backend)
  - [S3 Backend](#s3-backend)
  - [Variables](#variables)
- [Deploy the Docker Registry](#deploy-the-docker-registry)
- [Docker Setup](#docker-setup)
  - [Linux](#linux)
  - [MacOS](#macos)
- [Push the Image to the Docker Registry](#push-the-image-to-the-docker-registry)
- [Set up NGINX Reverse Proxy](#set-up-nginx-reverse-proxy)
- [Set up NGINX Load Balancer](#set-up-nginx-load-balancer)

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

Add the following to the `/etc/docker/daemon.json` file and restart the Docker service.

```/etc/docker/daemon.json
{
  "insecure-registries": ["PUBLIC_IP:5000"]
}
```

### MacOS

On MacOS, you need to configure this with Docker Desktop. Open Docker Desktop and navigate to the `Settings > Docker Engine` tab, then add the following to the JSON field and click `Apply & restart`.

```json
{
  "insecure-registries": ["PUBLIC_IP:5000"]
}
```

![docker desktop settings](/problem-2/images/docker-desktop-settings.png)

## Push the Image to the Docker Registry

On your local machine, pull the `yeasy/simple-web` image from Docker Hub and push it to the newly deployed Docker registry.

```bash
docker pull yeasy/simple-web
docker tag yeasy/simple-web:latest PUBLIC_IP:5000/simple-web:latest
docker push PUBLIC_IP:5000/simple-web:latest
```

![successful docker push](/problem-2/images/successful-docker-push.png)

## Set up NGINX Reverse Proxy

Now that the image is in the Docker registry, we can start deploying containers with the private Docker registry.

Uncomment the [nginx-reverse-proxy.tf](/problem-2/terraform/nginx-reverse-proxy.tf) file and run `terraform apply` to deploy an NGINX reverse proxy with a `yeasy/simple-web` container on a new EC2 instance. Once the EC2 instance is ready, go to the instance's public IP address to view the web page.

![nginx-reverse-proxy](/problem-2/images/nginx-reverse-proxy.png)

## Set up NGINX Load Balancer

Similar to how you set up the NGINX reverse proxy, uncomment the [nginx-load-balancer.tf](/problem-2/terraform/nginx-load-balancer.tf) file and run `terraform apply` to deploy an NGINX load balancer with 3 `yeasy/simple-web` containers on a new EC2 instance. Once the EC2 instance is ready, go to the instance's public IP address to view the web page. As you refresh the web page, you should see the target IP address change to 3 different values.

![nginx-load-balancer-1](/problem-2/images/nginx-load-balancer-1.png)
![nginx-load-balancer-2](/problem-2/images/nginx-load-balancer-2.png)
![nginx-load-balancer-3](/problem-2/images/nginx-load-balancer-3.png)
