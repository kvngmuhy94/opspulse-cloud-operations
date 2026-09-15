# OpsPulse — AWS Technical Operations & DevOps Portfolio Project

OpsPulse is a small production-style API used to demonstrate cloud operations and DevOps skills.

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
