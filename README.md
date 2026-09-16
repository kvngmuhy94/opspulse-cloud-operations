# OpsPulse — AWS Technical Operations & DevOps Portfolio Project

# OpsPulse – AWS Cloud Operations Portfolio Project

OpsPulse is a practical cloud operations and DevOps portfolio project designed to demonstrate hands-on skills in AWS, Docker, Terraform, Linux, monitoring, CI/CD, troubleshooting, and incident response.

The project deploys a containerised FastAPI application to Amazon EC2 using Terraform, validates code through GitHub Actions, exposes health and readiness endpoints, centralises application logs in Amazon CloudWatch, and includes a controlled outage simulation with troubleshooting and recovery.

---

## Project Overview

The aim of OpsPulse is to simulate the type of work carried out in Cloud Operations, Technical Operations, Platform Support, Production Support, and Junior DevOps roles.

Instead of only deploying an application, the project focuses on the full operational lifecycle:

- Provision infrastructure
- Deploy an application
- Configure monitoring
- Centralise logs
- Troubleshoot deployment issues
- Detect service failures
- Investigate incidents
- Restore service availability
- Document recovery procedures

---

## Architecture

```text
                    GitHub
                      |
                      |
               GitHub Actions
                      |
                      v
                 Source Code
                      |
                      v
                   Docker
                      |
                      v
              Amazon EC2 Instance
                      |
          ---------------------------
          |                         |
          v                         v
     FastAPI App              Amazon CloudWatch
     Port 8000                - CPU Monitoring
                              - Application Logs
                              - CloudWatch Alarms
## What this project demonstrates

- AWS EC2 deployment
- Linux administration and SSH
- Docker containerisation
- Terraform infrastructure as code
- GitHub Actions CI
- Health/readiness endpoints
- CloudWatch monitoring and alarms (next phase)
- Incident simulation and troubleshooting runbook (next phase)

## Architecture

GitHub -> GitHub Actions -> Docker image -> AWS EC2 -> OpsPulse API

Terraform provisions the EC2 infrastructure.

## Local run

```bash
docker build -t opspulse .
docker run --rm -p 8000:8000 -e APP_ENV=local opspulse
```

Open:

- http://localhost:8000/
- http://localhost:8000/health
- http://localhost:8000/docs

## Terraform

```bash
cd terraform
terraform init
terraform fmt
terraform validate
terraform plan -var="key_name=YOUR_KEY" -var="allowed_ssh_cidr=YOUR_IP/32"
terraform apply
```

## Portfolio story

This project is being built as a production-style technical operations environment with infrastructure-as-code, CI/CD, monitoring, security controls, and incident-response documentation.
