# OpsPulse — AWS Cloud Operations & DevOps Platform

![AWS](https://img.shields.io/badge/AWS-Cloud-orange)
![EC2](https://img.shields.io/badge/Amazon%20EC2-Compute-orange)
![CloudWatch](https://img.shields.io/badge/CloudWatch-Observability-purple)
![Terraform](https://img.shields.io/badge/Terraform-IaC-844FBA)
![Docker](https://img.shields.io/badge/Docker-Containers-2496ED)
![FastAPI](https://img.shields.io/badge/FastAPI-API-009688)
![GitHub Actions](https://img.shields.io/badge/GitHub%20Actions-CI%2FCD-black)
![Linux](https://img.shields.io/badge/Linux-Amazon%20Linux-yellow)
![Status](https://img.shields.io/badge/Status-Completed-brightgreen)

---

## Overview

**OpsPulse** is a production-style AWS cloud operations and DevOps portfolio project designed to demonstrate how application deployment, infrastructure automation, monitoring, logging, troubleshooting, and incident response can be brought together in a practical cloud environment.

The platform deploys a containerised FastAPI application to Amazon EC2 using Terraform, validates changes through GitHub Actions, exposes operational health endpoints, centralises application logs in Amazon CloudWatch, monitors infrastructure performance, and includes a controlled service outage simulation with recovery validation.

This project demonstrates enterprise-style operational practices covering:

- AWS cloud infrastructure
- Infrastructure as Code
- Docker containerisation
- CI/CD validation
- Linux administration
- Cloud monitoring
- Centralised logging
- IAM role-based security
- Health and readiness checks
- Incident investigation
- Service recovery
- Operational documentation

---

## Solution Architecture

```text
                           ┌─────────────────────┐
                           │      Developer      │
                           │   Local Workstation │
                           └─────────┬───────────┘
                                     │
                                     ▼
                           ┌─────────────────────┐
                           │       GitHub        │
                           │   Source Control    │
                           └─────────┬───────────┘
                                     │
                                     ▼
                           ┌─────────────────────┐
                           │   GitHub Actions    │
                           │     CI Workflow     │
                           └─────────┬───────────┘
                                     │
                                     ▼
                           ┌─────────────────────┐
                           │       Docker        │
                           │  Application Image  │
                           └─────────┬───────────┘
                                     │
                                     ▼
                    ┌────────────────────────────────┐
                    │          AWS Cloud             │
                    │                                │
                    │  ┌──────────────────────────┐  │
                    │  │       Amazon EC2         │  │
                    │  │      Amazon Linux        │  │
                    │  │                          │  │
                    │  │   ┌──────────────────┐   │  │
                    │  │   │  OpsPulse API    │   │  │
                    │  │   │ FastAPI/Uvicorn  │   │  │
                    │  │   │ Docker Container │   │  │
                    │  │   └──────────────────┘   │  │
                    │  └────────────┬─────────────┘  │
                    │               │                │
                    │               ▼                │
                    │  ┌──────────────────────────┐  │
                    │  │   Amazon CloudWatch      │  │
                    │  │                          │  │
                    │  │ • CPU Metrics            │  │
                    │  │ • CloudWatch Alarm       │  │
                    │  │ • Centralised Logs       │  │
                    │  │ • Operational Visibility │  │
                    │  └──────────────────────────┘  │
                    │                                │
                    │  ┌──────────────────────────┐  │
                    │  │          IAM             │  │
                    │  │ Role + Instance Profile  │  │
                    │  └──────────────────────────┘  │
                    │                                │
                    └────────────────────────────────┘

                      Infrastructure Provisioned
                            with Terraform
Operational Problem

Cloud-hosted applications need more than deployment alone.

Without appropriate operational controls, common issues include:

Application outages going unnoticed
Limited visibility into server health
Logs remaining isolated on individual machines
Manual infrastructure configuration
Inconsistent deployment steps
IAM permission failures
Difficult incident investigation
Slow service recovery
Lack of repeatable operational procedures

OpsPulse was designed to simulate how a modern cloud operations environment can improve deployment consistency, observability, troubleshooting, and recovery.

The project brings together:

automated infrastructure provisioning
application containerisation
monitoring
centralised logging
service health checks
operational troubleshooting
recovery procedures
Key Features
Terraform-based AWS infrastructure provisioning
Amazon EC2 application hosting
Docker containerisation
FastAPI web service
GitHub Actions CI workflow
Amazon CloudWatch CPU monitoring
CloudWatch alarm configuration
Centralised application logging
IAM role-based EC2 permissions
Health endpoint
Readiness endpoint
Swagger API documentation
Linux and SSH administration
Controlled outage simulation
Incident investigation workflow
Service recovery validation
Operational incident runbook
End-to-End Operational Flow
Developer Change
      ↓
Git Push
      ↓
GitHub Repository
      ↓
GitHub Actions CI
      ↓
Application Validation
      ↓
Docker Build
      ↓
Terraform Infrastructure Provisioning
      ↓
AWS EC2 Deployment
      ↓
FastAPI Container Running
      ↓
Health / Readiness Checks
      ↓
CloudWatch Metrics & Logs
      ↓
Alarm / Operational Monitoring
      ↓
Incident Investigation
      ↓
Recovery
      ↓
Service Validation
AWS Services Used
Service	Purpose
Amazon EC2	Hosts the OpsPulse application
Amazon CloudWatch	Monitoring, alarms, and centralised logs
AWS IAM	Role-based permissions for the EC2 instance
EC2 Security Groups	Controls inbound access
Amazon Linux	Operating system for the EC2 host
Terraform AWS Provider	Provisions and manages AWS infrastructure
Application Layer

The OpsPulse application is built using:

Python
FastAPI
Uvicorn

The service runs inside a Docker container on port:

8000

Application endpoints include:

Root
GET /
Health
GET /health

Example response:

{
  "status": "healthy",
  "environment": "production"
}
Readiness
GET /ready
API Documentation
GET /docs

FastAPI automatically exposes interactive Swagger documentation through /docs.

Docker Containerisation

The application is packaged into a Docker image.

Build
docker build -t opspulse .
Run
docker run -d \
  --name opspulse \
  --restart unless-stopped \
  -p 8000:8000 \
  -e APP_ENV=production \
  opspulse
Check Container
docker ps
Health Check
curl http://localhost:8000/health
Infrastructure as Code

Terraform is used to provision the AWS infrastructure.

The Terraform configuration manages:

EC2 instance
Security group
IAM role
IAM role policy attachment
IAM instance profile
CloudWatch log group
CloudWatch CPU alarm

Typical workflow:

terraform init
terraform fmt
terraform validate
terraform plan
terraform apply

This allows infrastructure to be:

version controlled
repeatable
reviewable
reproducible
easier to troubleshoot
IAM & Security

The EC2 instance uses an IAM role and instance profile rather than storing AWS access credentials directly on the server.

The instance profile is used to grant permissions required for monitoring and CloudWatch integration.

This supports a more secure workload authentication model.

The project also uses:

EC2 security groups
SSH key-based access
.pem key protection
IAM policy-based permissions

Example SSH key permission:

chmod 400 ~/.ssh/opspulse-key.pem
Monitoring & Observability

Amazon CloudWatch provides infrastructure monitoring and operational visibility.

CPU Monitoring

The EC2 instance publishes CPU metrics through:

AWS/EC2
CPUUtilization

A CloudWatch alarm is configured:

opspulse-high-cpu

The alarm monitors CPU utilisation and changes state when the configured threshold is exceeded.

Monitoring Features
CPU utilisation monitoring
CloudWatch alarm state
Centralised application logs
Application startup logs
HTTP request logs
Health endpoint verification
Readiness endpoint verification
Incident recovery verification
Centralised Application Logging

Docker application logs are sent directly to Amazon CloudWatch Logs.

Log Group
/opspulse/application
Production Log Stream
opspulse-production

The Docker container uses the AWS logs driver.

Example:

docker run -d \
  --name opspulse \
  --restart unless-stopped \
  -p 8000:8000 \
  -e APP_ENV=production \
  --log-driver=awslogs \
  --log-opt awslogs-region=eu-west-2 \
  --log-opt awslogs-group=/opspulse/application \
  --log-opt awslogs-stream=opspulse-production \
  opspulse

Example CloudWatch log events:

INFO: Started server process
INFO: Waiting for application startup
INFO: Application startup complete
INFO: Uvicorn running on http://0.0.0.0:8000
GET /health HTTP/1.1 200 OK
GET / HTTP/1.1 200 OK
GET /ready HTTP/1.1 200 OK
GET /docs HTTP/1.1 200 OK

This allows application activity to be reviewed without relying solely on local container logs.

CI/CD

GitHub Actions is used to provide continuous integration.

The CI workflow validates project changes when code is pushed to GitHub.

The pipeline demonstrates experience with:

source control
automated validation
GitHub workflow configuration
CI/CD concepts
repeatable engineering checks

Workflow location:

.github/workflows/ci.yml
Incident Simulation

A controlled production-style outage was performed as part of the project.

The OpsPulse container was deliberately stopped:

docker stop opspulse

After the container stopped, the application health endpoint failed:

curl http://localhost:8000/health

This simulated an application outage.

Incident Investigation

The following operational checks were used:

docker ps
docker ps -a
docker inspect opspulse --format='{{.State.Status}}'

The container state showed:

exited

This confirmed that the application outage was caused by the stopped Docker container.

Service Recovery

The service was restored using:

docker start opspulse

The container was then verified:

docker ps

Application health was tested:

curl http://localhost:8000/health

Readiness was tested:

curl http://localhost:8000/ready

Successful responses confirmed that the application had recovered.

CloudWatch logs were then reviewed to verify that successful HTTP requests were being recorded again.

Incident Response Flow
Healthy Service
      ↓
Controlled Container Stop
      ↓
Health Endpoint Fails
      ↓
Application Becomes Unavailable
      ↓
Docker Process Investigation
      ↓
Container State = Exited
      ↓
Container Restart
      ↓
Health Check Passes
      ↓
Readiness Check Passes
      ↓
CloudWatch Logs Confirm Recovery
Incident Runbook

A dedicated operational runbook is included:

docs/incident-runbook.md

The runbook documents:

incident symptoms
health checks
container inspection
container state verification
application log checks
recovery steps
CloudWatch verification
lessons learned

This creates a repeatable operational process for handling similar incidents.

Troubleshooting Experience

The project involved resolving several real implementation issues.

Docker Daemon Not Running

Docker commands initially failed because the Docker daemon was unavailable.

The Docker environment was started before rebuilding the image.

Missing Dockerfile

A Docker build failed because the command was executed from the wrong directory.

The correct project directory was identified before rebuilding.

Port Conflict

Docker returned:

Bind for 0.0.0.0:8000 failed: port is already allocated

The conflicting container was identified using:

docker ps

The old container was removed before starting the correct deployment.

Invalid AWS Credentials

AWS CLI initially returned:

InvalidClientTokenId

The AWS profile was reconfigured.

Identity was verified using:

aws sts get-caller-identity
IAM Permission Errors

Terraform initially encountered multiple AWS permission errors.

Examples included:

ec2:DescribeImages
logs:CreateLogGroup
logs:DescribeLogGroups
iam:CreateRole

The required IAM permissions were identified and added before rerunning the infrastructure deployment.

EC2 Key Pair Issue

Terraform could not launch the EC2 instance because the referenced key pair did not exist.

The correct EC2 key pair was created in the AWS London region.

SSH Authentication Issue

SSH initially failed with:

Permission denied (publickey)

The correct private key was used and file permissions were corrected.

Terraform Syntax Errors

Terraform configuration errors included:

invalid block definitions
duplicate provider configuration
duplicate resource declarations
malformed syntax

These were corrected using:

terraform fmt
terraform validate
CloudWatch Permission Errors

Terraform initially lacked permission to create and query CloudWatch resources.

The relevant CloudWatch permissions were added before continuing.

Operational Commands
Check Running Containers
docker ps
Check All Containers
docker ps -a
Inspect Container State
docker inspect opspulse --format='{{.State.Status}}'
View Recent Logs
docker logs --tail 100 opspulse
Restart Container
docker restart opspulse
Health Check
curl http://localhost:8000/health
Readiness Check
curl http://localhost:8000/ready
Technologies Used
Cloud
AWS
Amazon EC2
Amazon CloudWatch
AWS IAM
Infrastructure
Terraform
Infrastructure as Code
Containers
Docker
Application
Python
FastAPI
Uvicorn
CI/CD
GitHub
GitHub Actions
Operations
Linux
Amazon Linux
SSH
Bash
Curl
Monitoring
CloudWatch Metrics
CloudWatch Logs
CloudWatch Alarms
Health checks
Readiness checks
Skills Demonstrated
AWS cloud engineering
EC2 administration
Infrastructure as Code
Terraform
Docker containerisation
GitHub Actions
CI/CD
IAM troubleshooting
Cloud monitoring
Centralised logging
Linux administration
SSH
Networking
Health checks
Operational troubleshooting
Incident investigation
Service recovery
Root-cause analysis
Operational documentation
Operational Evidence
CloudWatch CPU Alarm

The project includes an active CloudWatch CPU alarm:

opspulse-high-cpu
Centralised Logs

Application logs are stored in:

/opspulse/application

with the stream:

opspulse-production
Health Validation

The application exposes:

/health
/ready
/docs

for operational testing and API visibility.

Screenshots

You can create a folder such as:

screenshots/

and add screenshots from the project.

Recommended structure:

screenshots/
├── github-actions-success.png
├── terraform-apply-success.png
├── opspulse-health.png
├── cloudwatch-alarm.png
├── cloudwatch-logs.png
├── docker-container-running.png
└── incident-recovery.png

Then display them in the README like this:

CloudWatch Monitoring
![CloudWatch Alarm](screenshots/cloudwatch-alarm.png)
Centralised Logging
![CloudWatch Logs](screenshots/cloudwatch-logs.png)
Application Health
![OpsPulse Health](screenshots/opspulse-health.png)
Terraform Deployment
![Terraform Apply](screenshots/terraform-apply-success.png)
GitHub Actions
![GitHub Actions](screenshots/github-actions-success.png)
Repository Structure
opspulse-cloud-operations/
│
├── .github/
│   └── workflows/
│       └── ci.yml
│
├── app/
│   └── main.py
│
├── docs/
│   └── incident-runbook.md
│
├── terraform/
│   └── main.tf
│
├── screenshots/
│   ├── cloudwatch-alarm.png
│   ├── cloudwatch-logs.png
│   ├── opspulse-health.png
│   └── incident-recovery.png
│
├── Dockerfile
├── requirements.txt
├── .dockerignore
├── .gitignore
└── README.md
What I Learned

OpsPulse provided practical experience connecting multiple technologies into one operational cloud environment.

The project demonstrated that deploying an application is only one part of cloud operations.

A reliable service also requires:

Application
    +
Infrastructure
    +
Automation
    +
Monitoring
    +
Logging
    +
Security
    +
Troubleshooting
    +
Incident Response
    +
Recovery
    +
Documentation

The project also provided hands-on experience troubleshooting real problems across AWS, Terraform, Docker, Linux, IAM, networking, and application operations.

Future Improvements

Planned improvements include:

CloudWatch dashboard
Memory monitoring
Disk monitoring
CloudWatch Agent
SNS email notifications
Automated availability alarms
HTTPS
Custom domain
Nginx reverse proxy
Amazon ECR
Automated Docker image deployment
Expanded GitHub Actions pipeline
Automated EC2 deployment
Secrets management
Least-privilege IAM policies
Automated container restart monitoring
Load balancer
Auto Scaling
Infrastructure modules
Remote Terraform state
Terraform state locking
Cost monitoring
Project Status
✅ FastAPI application
✅ Docker containerisation
✅ GitHub repository
✅ GitHub Actions CI
✅ Terraform infrastructure
✅ AWS EC2 deployment
✅ Amazon Linux host
✅ Security group
✅ IAM role
✅ IAM instance profile
✅ CloudWatch CPU monitoring
✅ CloudWatch alarm
✅ Centralised application logging
✅ Health endpoint
✅ Readiness endpoint
✅ API documentation
✅ SSH access
✅ Incident simulation
✅ Troubleshooting workflow
✅ Service recovery
✅ Incident runbook
Documentation
Incident Response Runbook

Additional documentation can be added for:

Architecture
Deployment
Monitoring
Troubleshooting
Security
CI/CD
Author

Amos Agboola

Cloud Operations | Technical Operations | DevOps | AWS

This project was created as part of a practical cloud engineering portfolio focused on operational reliability, infrastructure automation, monitoring, troubleshooting, and production-style incident response
