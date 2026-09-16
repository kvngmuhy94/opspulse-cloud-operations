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
Technology Stack
Cloud
Amazon Web Services
Amazon EC2
Amazon CloudWatch
AWS IAM
Infrastructure as Code
Terraform
Containers
Docker
Application
Python
FastAPI
Uvicorn
CI/CD
GitHub Actions
Operating System
Amazon Linux 2023
Linux command line
Version Control
Git
GitHub
Application Endpoints

OpsPulse exposes several endpoints for operational testing.

Root
GET /

Basic application response.

Health Check
GET /health

Example response:

{
  "status": "healthy",
  "environment": "production"
}

This endpoint can be used to check whether the application is responding correctly.

Readiness Check
GET /ready

Used to confirm that the application is ready to receive traffic.

API Documentation
GET /docs

FastAPI automatically provides interactive Swagger API documentation.

Docker

The application is packaged into a Docker image.

Example build:

docker build -t opspulse .

Run locally:

docker run -d \
  --name opspulse \
  -p 8000:8000 \
  -e APP_ENV=production \
  opspulse

Verify:

docker ps

Test the application:

curl http://localhost:8000/health
AWS Deployment

The application is deployed to an Amazon EC2 instance running Amazon Linux.

Terraform provisions the infrastructure required for the environment.

Resources include:

EC2 instance
Security group
IAM role
IAM instance profile
CloudWatch log group
CloudWatch CPU alarm

The application container runs on:

Port 8000
Infrastructure as Code

Terraform is used to manage the AWS infrastructure.

Typical workflow:

terraform init
terraform fmt
terraform validate
terraform plan
terraform apply

This allows the cloud infrastructure to be defined, reviewed, version-controlled, and reproduced.

IAM Configuration

An IAM role is attached to the EC2 instance through an instance profile.

The EC2 role uses:

CloudWatchAgentServerPolicy

This allows the instance to interact with Amazon CloudWatch without storing AWS access keys directly on the server.

This follows the principle of using role-based AWS authentication for workloads.

Monitoring

Amazon CloudWatch is used for infrastructure monitoring.

A CPU utilisation alarm is configured for the EC2 instance.

Alarm:

opspulse-high-cpu

The alarm monitors:

AWS/EC2
CPUUtilization

and triggers when CPU utilisation exceeds the configured threshold.

This provides visibility into infrastructure resource usage.

Centralised Application Logging

Application logs are sent from Docker directly to Amazon CloudWatch Logs.

Log group:

/opspulse/application

Production log stream:

opspulse-production

The Docker container uses the AWS logging driver.

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

CloudWatch logs capture events such as:

Application startup complete
Uvicorn running on http://0.0.0.0:8000
GET /health HTTP/1.1 200 OK
GET /ready HTTP/1.1 200 OK
GET /docs HTTP/1.1 200 OK

This makes application activity visible without needing to connect directly to the server.

CI Pipeline

GitHub Actions is configured to run automated checks when changes are pushed to the repository.

The CI workflow provides automated validation before changes are accepted.

This demonstrates experience working with:

Automated pipelines
GitHub Actions
Source-controlled infrastructure and application code
Incident Simulation

A controlled production-style outage was performed as part of the project.

The OpsPulse Docker container was deliberately stopped:

docker stop opspulse

The health endpoint then became unavailable:

curl http://localhost:8000/health

The connection failed, confirming the service outage.

Incident Investigation

The following commands were used during investigation:

docker ps
docker ps -a
docker inspect opspulse --format='{{.State.Status}}'

The investigation showed that the OpsPulse container had exited.

This demonstrated how container state can be used during production troubleshooting.

Service Recovery

The application was restored using:

docker start opspulse

The container status was verified:

docker ps

Health was then confirmed:

curl http://localhost:8000/health

Readiness was verified using:

curl http://localhost:8000/ready

The application returned to a healthy state.

CloudWatch Logs were then checked to confirm that successful application requests were being received again after recovery.

Incident Response Workflow

The incident exercise followed this process:

Healthy Service
      |
      v
Container Stopped
      |
      v
Health Check Fails
      |
      v
Docker Investigation
      |
      v
Stopped Container Identified
      |
      v
Container Restarted
      |
      v
Health Check Restored
      |
      v
CloudWatch Logs Confirm Recovery
Incident Runbook

A dedicated operational runbook is included in the repository:

docs/incident-runbook.md

The runbook documents:

Symptoms
Health checks
Docker inspection commands
CloudWatch verification
Recovery procedures
Incident lessons learned

This provides a repeatable troubleshooting process for future outages.

Troubleshooting Experience

Several real deployment and cloud operations issues were encountered and resolved while building the project.

Docker Daemon Not Running

Docker initially failed because the Docker daemon was not running.

The issue was identified and Docker Desktop was started before rebuilding the application.

Missing Dockerfile

A Docker build failed because the command was executed from the wrong directory.

The correct project directory was identified before rebuilding the image.

Port Conflict

The application initially failed with:

Bind for 0.0.0.0:8000 failed: port is already allocated

The container already using port 8000 was identified using:

docker ps

The conflicting container was removed before redeploying OpsPulse.

Invalid AWS Credentials

AWS CLI initially returned:

InvalidClientTokenId

The AWS profile was reconfigured with the correct access key and secret key.

Identity was then verified using:

aws sts get-caller-identity
IAM Permission Errors

Terraform encountered several IAM permission errors while creating infrastructure and monitoring resources.

Examples included:

ec2:DescribeImages
logs:CreateLogGroup
logs:DescribeLogGroups
iam:CreateRole

The required IAM permissions were identified and added before rerunning Terraform.

This provided practical experience with AWS IAM troubleshooting.

EC2 Key Pair Issue

Terraform initially failed to create the EC2 instance because the referenced key pair did not exist.

The correct key pair was created in the London AWS region.

SSH private key permissions were also corrected using:

chmod 400 ~/.ssh/opspulse-key.pem
SSH Authentication Issue

SSH initially failed with:

Permission denied (publickey)

The correct .pem file was identified and used.

Successful SSH access was then established to the Amazon Linux EC2 instance.

Skills Demonstrated

This project demonstrates practical experience with:

AWS
Amazon EC2
Amazon CloudWatch
AWS IAM
Terraform
Infrastructure as Code
Docker
Python
FastAPI
Linux
SSH
Git
GitHub
GitHub Actions
CI/CD
Cloud monitoring
Centralised logging
Health checks
Production troubleshooting
Incident response
Root-cause investigation
Service recovery
Operational documentation
Operational Commands
Check container
docker ps
Check all containers
docker ps -a
Check container state
docker inspect opspulse --format='{{.State.Status}}'
Health check
curl http://localhost:8000/health
Readiness check
curl http://localhost:8000/ready
Restart service
docker restart opspulse
Check logs
docker logs --tail 100 opspulse
What I Learned

Building OpsPulse provided practical experience beyond following individual cloud tutorials.

The project required connecting multiple technologies together and troubleshooting real integration issues across:

AWS permissions
Docker networking
Linux
SSH
Terraform
CloudWatch
GitHub
application deployment

It also demonstrated the importance of observability and incident response when operating applications in a cloud environment.

The biggest lesson was that deploying an application is only one part of cloud operations.

A production service also requires:

Deployment
+
Monitoring
+
Logging
+
Security
+
Troubleshooting
+
Recovery
+
Documentation
Future Improvements

Planned improvements include:

CloudWatch dashboard
Memory and disk monitoring
CloudWatch Agent
SNS alert notifications
HTTPS
Domain name
Reverse proxy
Automated EC2 deployment
Improved GitHub Actions deployment pipeline
Container registry
Amazon ECR integration
Automated health monitoring
Infrastructure hardening
Least-privilege IAM policies
Automated recovery
Project Status

Current capabilities:

✅ FastAPI application
✅ Docker containerisation
✅ GitHub repository
✅ GitHub Actions CI
✅ Terraform infrastructure
✅ AWS EC2 deployment
✅ Security group configuration
✅ IAM role and instance profile
✅ CloudWatch CPU monitoring
✅ CloudWatch alarm
✅ Centralised application logs
✅ Health endpoint
✅ Readiness endpoint
✅ Incident simulation
✅ Service recovery
✅ Incident response runbook
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
├── Dockerfile
├── requirements.txt
├── .dockerignore
├── .gitignore
└── README.md
Author

Amos Agboola

Cloud / Technical Operations / DevOps Portfolio Project


One thing before you replace your current README: make a backup first.

```bash
cp README.md README-old.md

Then replace the README using:

nano README.md

Paste the content above, save with Ctrl+O → Enter → Ctrl+X, then run:

git add README.md
git commit -m "Upgrade OpsPulse project documentation"
git push

After that, I’d move to the CloudWatch dashboard. That gives us a visual architecture/monitoring piece that will look particularly good in the GitHub repo and on LinkedIn.
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
