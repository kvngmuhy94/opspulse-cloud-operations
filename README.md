# OpsPulse

## AWS Cloud Operations & Monitoring Platform

OpsPulse is a production-style cloud operations project designed to demonstrate the deployment, monitoring, alerting, and operational support of a containerised application running on AWS.

The project combines **FastAPI, Docker, AWS EC2, Terraform, Amazon CloudWatch, Amazon SNS, IAM, and GitHub** to demonstrate a complete cloud operations workflow.

The project follows the operational lifecycle:

**Build → Containerise → Provision → Deploy → Monitor → Alert → Troubleshoot → Recover**

---

## Overview

OpsPulse consists of a lightweight FastAPI application running inside a Docker container on an Amazon EC2 instance.

AWS infrastructure is provisioned and managed using Terraform.

The application provides health and readiness endpoints, while Amazon CloudWatch provides centralised logging, infrastructure monitoring, dashboards, and alarms.

Amazon SNS is integrated with CloudWatch to provide automated email notifications when monitored infrastructure enters an alarm state.

The project was built to demonstrate practical skills relevant to:

- Cloud Operations Engineering
- DevOps Engineering
- Technical Operations
- Platform Support
- Cloud Support Engineering
- Infrastructure Engineering

---

## Architecture

```text
                       GitHub
                          │
                          ▼
                  Application Code
                          │
                          ▼
                       Docker
                          │
                          ▼
                  AWS EC2 Instance
                          │
                          ▼
                    OpsPulse API
                   ┌──────┴──────┐
                   │             │
                   ▼             ▼
             Health Checks    Application Logs
             /health          /opspulse/application
             /ready                 │
                   │                 │
                   └────────┬────────┘
                            ▼
                    Amazon CloudWatch
                   ┌────────┴────────┐
                   │                 │
                   ▼                 ▼
             Operations          CPU Alarm
              Dashboard              │
                                     ▼
                               Amazon SNS
                                     │
                                     ▼
                             Email Notification
Technology Stack
Technology	Purpose
Python	Application development
FastAPI	REST API framework
Uvicorn	ASGI application server
Docker	Application containerisation
AWS EC2	Cloud compute infrastructure
Terraform	Infrastructure as Code
AWS IAM	Secure service permissions
Amazon CloudWatch	Metrics, logs, dashboards and alarms
Amazon SNS	Email alert notifications
Git	Source control
GitHub	Repository and project version control
Core Features

OpsPulse includes:

Containerised FastAPI application
AWS EC2 deployment
Terraform-managed infrastructure
Restricted SSH access
IAM role-based AWS permissions
Application health monitoring
Application readiness monitoring
Centralised CloudWatch logging
CloudWatch infrastructure metrics
CloudWatch operations dashboard
High-CPU monitoring
Automated SNS email alerts
Alarm recovery notifications
Incident-response documentation
Git-based version control
Application Endpoints
Root Endpoint
/

Confirms that the OpsPulse API is accessible.

Health Check
/health

Used to confirm that the application is running.

Example response:

{
  "status": "healthy",
  "environment": "production"
}
Readiness Check
/ready

Used to determine whether the service is ready to receive requests.

This type of endpoint is useful for monitoring platforms, container orchestrators, and load balancers.

API Documentation
/docs

FastAPI automatically provides interactive Swagger/OpenAPI documentation.

Containerisation

The application is packaged as a Docker image.

Containerisation provides a consistent runtime environment and allows the same application image to operate across development and cloud environments.

The OpsPulse container exposes:

Port 8000

The production container uses an automatic restart policy:

--restart unless-stopped

This allows Docker to restart the service automatically after unexpected container or host interruptions.

Docker Build
docker build -t opspulse .
Docker Runtime

The production deployment uses configuration similar to:

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
AWS Infrastructure

OpsPulse is deployed in the AWS London Region:

eu-west-2

The cloud environment includes:

EC2 compute
Security groups
IAM roles
IAM instance profiles
CloudWatch logs
CloudWatch alarms
CloudWatch dashboard
SNS notifications
Infrastructure as Code

Terraform is used to provision and manage the AWS infrastructure.

Infrastructure as Code allows the environment to be defined in configuration files rather than being dependent on manually created resources.

Terraform manages resources including:

EC2 instance
Security group
IAM role
IAM instance profile
CloudWatch log group
CloudWatch monitoring alarm
CloudWatch dashboard
SNS topic
SNS email subscription

This provides:

Repeatability
Version control
Infrastructure consistency
Change visibility
Faster recovery
Reduced configuration drift
Terraform Workflow

Infrastructure changes are managed using:

terraform init
terraform fmt
terraform validate
terraform plan
terraform apply

terraform plan is reviewed before deployment to identify resources that Terraform intends to:

Create
Modify
Replace
Destroy

This helps reduce unintended infrastructure changes.

Security
Security Groups

Network access to the EC2 instance is controlled using an AWS security group.

SSH access is restricted to an authorised public IP address instead of being exposed to the entire internet.

The FastAPI application is exposed through:

TCP Port 8000
IAM

The EC2 instance uses an IAM role and instance profile.

This allows the server to access required AWS services without storing permanent AWS access keys directly on the instance.

IAM permissions are used for services such as CloudWatch logging and monitoring.

Centralised Logging

Docker application logs are forwarded directly to Amazon CloudWatch Logs.

CloudWatch Log Group
/opspulse/application
Log Stream
opspulse-production

Centralised logging allows application activity to be investigated without relying solely on local EC2 log files.

CloudWatch captures information including:

Application startup
Uvicorn startup
HTTP requests
Health checks
Readiness checks
API documentation requests
HTTP status responses
Operations Dashboard

A dedicated Amazon CloudWatch dashboard provides visibility into the OpsPulse environment.

The dashboard allows infrastructure and application behaviour to be reviewed from a central location.

Monitored information includes:

EC2 CPU utilisation
Network activity
EC2 status information
Application activity
CloudWatch logs
Alarm state

This provides an operational view of the service and underlying infrastructure.

Monitoring and Alerting
High CPU Alarm

A CloudWatch alarm monitors the CPU utilisation of the EC2 instance.

Alarm
opspulse-high-cpu
Configuration
Setting	Value
Metric	CPUUtilization
Namespace	AWS/EC2
Statistic	Average
Threshold	Greater than 70%
Period	300 seconds
Evaluation periods	2

If CPU utilisation exceeds the configured threshold for the required evaluation periods, the alarm enters the:

ALARM

state.

Amazon SNS Alerting

The CloudWatch CPU alarm is connected to an Amazon SNS topic:

opspulse-alerts

The notification workflow is:

EC2
 │
 ▼
CloudWatch Metric
 │
 ▼
CloudWatch Alarm
 │
 ▼
Amazon SNS
 │
 ▼
Email Notification

When the alarm changes from:

OK → ALARM

an email alert is generated.

Recovery notifications are also configured for:

ALARM → OK

This allows the operator to know both when an incident begins and when the monitored resource returns to normal operation.

Alert Validation

The complete alerting workflow was tested end-to-end.

The CloudWatch alarm was manually moved into the ALARM state using the AWS CLI:

aws cloudwatch set-alarm-state \
  --alarm-name opspulse-high-cpu \
  --state-value ALARM \
  --state-reason "Testing OpsPulse SNS email notification" \
  --region eu-west-2

The SNS email notification was successfully received.

The alarm was subsequently returned to the OK state to validate recovery behaviour.

This confirmed the complete operational path:

CloudWatch Metric
        │
        ▼
CloudWatch Alarm
        │
        ▼
Amazon SNS
        │
        ▼
Email Notification
Health Monitoring

OpsPulse provides application-level monitoring using health and readiness endpoints.

Local validation:

curl http://localhost:8000/health

Remote validation:

curl http://<EC2-PUBLIC-IP>:8000/health

Expected response:

{
  "status": "healthy",
  "environment": "production"
}

Health endpoints make it possible to distinguish between:

A running EC2 instance
A running Docker container
A functioning application

This is important because an infrastructure resource may be operational while the application itself is unavailable.

Incident Response

The project includes an incident-response runbook:

docs/incident-runbook.md

The runbook provides a structured process for investigating OpsPulse service incidents.

A typical investigation follows:

User reports service problem
           │
           ▼
     Check /health
           │
           ▼
   Check EC2 status
           │
           ▼
 Check Docker container
           │
           ▼
 Review CloudWatch logs
           │
           ▼
Review CloudWatch metrics
           │
           ▼
 Check CloudWatch alarms
           │
           ▼
Take corrective action
           │
           ▼
Validate /health & /ready
Troubleshooting Experience

The project involved resolving several realistic cloud and infrastructure issues.

These included:

SSH authentication and connectivity problems
SSH private-key permissions
Security-group configuration errors
Incorrect source-IP configuration
Docker port conflicts
Container recreation
IAM permission errors
CloudWatch integration problems
Terraform configuration changes
Terraform-managed EC2 replacement
Public IP changes following infrastructure replacement
Application redeployment after EC2 replacement
Git remote conflicts
Terraform configuration validation
SNS subscription validation
CloudWatch alarm testing

A major part of the project involved restoring the OpsPulse application after an EC2 instance was replaced.

The replacement required:

Updating network access
Connecting to the new instance
Cloning the application repository
Rebuilding the Docker image
Starting the production container
Reconnecting CloudWatch logging
Testing /health
Testing /ready
Confirming CloudWatch logs
Validating alarm notifications

This demonstrated recovery and troubleshooting skills in addition to initial deployment skills.

Repository Structure
opspulse-cloud-operations/
│
├── app/
│   └── main.py
│
├── terraform/
│   └── main.tf
│
├── docs/
│   └── incident-runbook.md
│
├── Dockerfile
├── requirements.txt
├── .gitignore
└── README.md
Git Workflow

Project changes are managed through Git and GitHub.

Typical workflow:

git status
git add .
git commit -m "Describe change"
git push origin main

Temporary Terraform backup files are excluded through .gitignore to prevent local working files from being committed to the repository.

Operational Scenario

If OpsPulse becomes unavailable, the incident can be investigated systematically.

1. Test the application
curl http://<EC2-PUBLIC-IP>:8000/health
2. Confirm EC2 availability

Verify that the AWS EC2 instance is running and passing status checks.

3. Check the Docker container
docker ps
4. Review application logs

Inspect the CloudWatch log group:

/opspulse/application
5. Review infrastructure metrics

Check:

CPU utilisation
Network activity
Instance status
6. Review alarms

Confirm whether:

opspulse-high-cpu

has entered the ALARM state.

7. Perform recovery

Restart or redeploy the Docker container if necessary.

8. Validate recovery

Confirm:

/health
/ready

return successful responses.

Skills Demonstrated

OpsPulse demonstrates hands-on knowledge of:

AWS
Amazon EC2
IAM
Security Groups
CloudWatch
SNS
AWS CLI
Infrastructure
Terraform
Infrastructure as Code
Infrastructure lifecycle management
Cloud networking
IAM permissions
Containers
Docker
Docker images
Container lifecycle management
Docker logging
Port mapping
Monitoring
CloudWatch Metrics
CloudWatch Logs
CloudWatch Alarms
CloudWatch Dashboards
SNS alerting
Health checks
Readiness checks
Operations
Incident investigation
Troubleshooting
Service recovery
Log analysis
Monitoring
Alert validation
Infrastructure recovery
Development Workflow
Git
GitHub
Version control
Documentation
Project Status

OpsPulse is complete.

Implemented and validated:

✅ FastAPI application
✅ Production health endpoint
✅ Readiness endpoint
✅ Interactive API documentation
✅ Docker containerisation
✅ AWS EC2 hosting
✅ Terraform Infrastructure as Code
✅ Security-group configuration
✅ Restricted SSH access
✅ IAM role and instance profile
✅ CloudWatch centralised logging
✅ CloudWatch CPU monitoring
✅ CloudWatch operations dashboard
✅ High-CPU alarm
✅ Amazon SNS topic
✅ Email alarm notifications
✅ Alarm-state validation
✅ Recovery notifications
✅ Incident-response runbook
✅ Infrastructure recovery testing
✅ GitHub version control
✅ Project documentation
Key Learning Outcomes

OpsPulse provided practical experience across the full lifecycle of a cloud-hosted application.

The project demonstrated that cloud operations involves more than simply launching an EC2 instance.

It required understanding how application, container, network, infrastructure, identity, monitoring, logging, and alerting components interact.

Key learning areas included:

Designing repeatable cloud infrastructure
Managing AWS resources through Terraform
Running containerised workloads in production-style environments
Applying IAM permissions
Restricting infrastructure access
Centralising application logs
Monitoring infrastructure health
Creating automated alerts
Troubleshooting connectivity problems
Recovering an application following infrastructure replacement
Validating service recovery
Maintaining infrastructure code through Git
Project Summary

OpsPulse demonstrates an end-to-end cloud operations environment using:

FastAPI + Docker + AWS EC2 + Terraform + CloudWatch + SNS

The application is containerised and deployed on AWS EC2 using Terraform-managed infrastructure.

CloudWatch provides centralised logs, metrics, dashboards, and infrastructure monitoring.

A high-CPU CloudWatch alarm is connected to Amazon SNS to provide automated email notification when infrastructure enters an alarm state.

Health and readiness endpoints provide application-level visibility, while an incident-response runbook provides a structured troubleshooting process.

The alerting workflow has been validated end-to-end.

Author

Amos Agboola

Cloud / DevOps Portfolio Project

OpsPulse was built as a practical demonstration of cloud infrastructure deployment, monitoring, alerting, automation, troubleshooting, and operational support using AWS and modern DevOps tooling.


### Final GitHub step

Replace your existing `README.md` with this version, save it, and run:

```bash
cd ~/Downloads/opspulse-portfolio

git add README.md

git commit -m "Finalize OpsPulse project documentation"

git push origin main

After that, I would mark OpsPulse as completed rather than continuing to add random features. It now tells a coherent story from infrastructure provisioning through monitoring and incident recovery, which is more valuable for your portfolio than endlessly expanding one project.

Add solution architecture design 

Yes — add a dedicated Solution Architecture Design section to the README. For GitHub, I recommend using a Mermaid diagram because it renders directly inside the README and looks much more professional than plain ASCII.

Place this section after Overview and before Technology Stack:

# Solution Architecture Design

OpsPulse follows a simple production-style AWS architecture focused on deployment, observability, monitoring, alerting, and operational support.

```mermaid
flowchart TD

    DEV[Developer / GitHub Repository]

    DEV --> TF[Terraform Infrastructure as Code]

    TF --> AWS[AWS Cloud Environment]

    AWS --> SG[Security Group]
    AWS --> IAM[IAM Role & Instance Profile]
    AWS --> EC2[Amazon EC2 Instance]
    AWS --> CW[Amazon CloudWatch]
    AWS --> SNS[Amazon SNS]

    SG --> EC2
    IAM --> EC2

    EC2 --> DOCKER[Docker Engine]
    DOCKER --> API[OpsPulse FastAPI Application]

    API --> HEALTH[/health Endpoint]
    API --> READY[/ready Endpoint]
    API --> DOCS[/docs Endpoint]

    DOCKER --> LOGS[Application Logs]

    LOGS --> CWLOGS[CloudWatch Logs]
    EC2 --> METRICS[EC2 Metrics]

    METRICS --> CW
    CWLOGS --> CW

    CW --> DASH[CloudWatch Dashboard]
    CW --> ALARM[opspulse-high-cpu Alarm]

    ALARM --> SNS
    SNS --> EMAIL[Email Notification]

    EMAIL --> OPS[Cloud / Operations Engineer]

    OPS --> INVESTIGATE[Investigate Incident]
    INVESTIGATE --> HEALTH
    INVESTIGATE --> CWLOGS
    INVESTIGATE --> DASH
Architecture Components
GitHub

GitHub acts as the central source-control repository for:

FastAPI application code
Docker configuration
Terraform infrastructure code
Incident-response documentation
Project documentation

All project changes are tracked through Git.

Terraform

Terraform provides the Infrastructure as Code layer.

Terraform is responsible for provisioning and managing AWS resources including:

EC2 instance
Security group
IAM role
IAM instance profile
CloudWatch log group
CloudWatch alarm
CloudWatch dashboard
SNS topic
SNS subscription

This allows the environment to be recreated consistently and infrastructure changes to be reviewed before deployment.

Amazon EC2

Amazon EC2 provides the compute layer for OpsPulse.

The EC2 instance hosts:

Amazon Linux
      │
      ▼
Docker Engine
      │
      ▼
OpsPulse Container
      │
      ▼
FastAPI Application

The application listens on:

TCP Port 8000
Docker

Docker packages the FastAPI application and its dependencies into a portable container.

The container provides:

Consistent application runtime
Dependency isolation
Simplified deployment
Automatic restart capability
CloudWatch log forwarding
FastAPI Application

The application exposes operational endpoints including:

/

Main application endpoint.

/health

Confirms that the application is running.

/ready

Confirms that the application is ready to process requests.

/docs

Provides Swagger/OpenAPI documentation.

Security Group

The AWS security group provides the network-security layer.

It controls access to the EC2 instance.

SSH access is restricted to an authorised IP address, while the application is made available through its configured application port.

This follows the principle of reducing unnecessary infrastructure exposure.

IAM

The EC2 instance uses an IAM role and instance profile to access AWS services.

This avoids storing permanent AWS credentials directly on the server.

IAM permissions allow the instance to interact with services required by OpsPulse, including CloudWatch.

Amazon CloudWatch Logs

Docker application logs are forwarded to:

/opspulse/application

using the log stream:

opspulse-production

This provides centralised log storage and allows incidents to be investigated without depending exclusively on local EC2 logs.

CloudWatch Metrics

Amazon CloudWatch collects infrastructure metrics from the EC2 instance.

One of the primary monitored metrics is:

CPUUtilization

This provides visibility into server resource usage.

CloudWatch Alarm

The monitoring architecture includes:

opspulse-high-cpu

The alarm monitors EC2 CPU utilisation.

Current configuration:

Metric: CPUUtilization

Statistic: Average

Threshold: > 70%

Period: 300 seconds

Evaluation periods: 2

When the threshold conditions are met, the alarm moves from:

OK → ALARM
Amazon SNS

The CloudWatch alarm publishes notifications to the SNS topic:

opspulse-alerts

SNS then delivers the alert through email.

The alerting architecture is:

EC2 CPU Utilisation
        │
        ▼
CloudWatch Metric
        │
        ▼
CloudWatch Alarm
        │
        ▼
Amazon SNS
        │
        ▼
Email Alert
        │
        ▼
Operations Engineer

Recovery notifications are also configured.

When infrastructure returns to its normal state:

ALARM → OK

SNS can send a recovery notification.

Observability Architecture

OpsPulse combines three important areas of observability:

Logs
FastAPI
   │
   ▼
Docker
   │
   ▼
CloudWatch Logs

Used for investigating application behaviour and requests.

Metrics
EC2
 │
 ▼
CloudWatch Metrics

Used to monitor infrastructure performance.

Alerts
CloudWatch Metric
       │
       ▼
CloudWatch Alarm
       │
       ▼
SNS
       │
       ▼
Email

Used to notify operators when abnormal conditions occur.

Together, these provide visibility into both application and infrastructure health.

Incident Detection and Recovery Flow

This architecture demonstrates both proactive monitoring and structured incident response.

Architecture Principles

The OpsPulse design demonstrates several cloud and DevOps principles:

Infrastructure as Code
Containerisation
Least-privilege access
Centralised logging
Infrastructure monitoring
Automated alerting
Application health checks
Operational visibility
Incident response
Service recovery
Version-controlled infrastructure
Repeatable deployment
Architecture Summary

The complete OpsPulse architecture can be summarised as:

GitHub
   │
   ▼
Terraform
   │
   ▼
AWS
   │
   ├──────── Security Group
   │
   ├──────── IAM
   │
   └──────── EC2
               │
               ▼
             Docker
               │
               ▼
            FastAPI
          ┌────┼─────┐
          │    │     │
          ▼    ▼     ▼
      /health /ready /docs
               │
               ▼
        CloudWatch Logs
               │
               ▼
          CloudWatch
          ┌────┴─────┐
          │          │
          ▼          ▼
      Dashboard     Alarm
                      │
                      ▼
                     SNS
                      │
                      ▼
                    Email
                      │
                      ▼
              Operations Engineer

This is the version I would use in the finished README because it makes the project look like a **designed cloud solution**, rather than just a collection of AWS services.

For an interview, the simplest way to explain this architecture is:

> “OpsPulse is built around an EC2-hosted Docker application. Terraform provisions the infrastructure, IAM controls AWS permissions, security groups control network access, CloudWatch collects logs and metrics, and a CloudWatch alarm sends events through SNS to email. Health and readiness endpoints provide application-level monitoring, while the CloudWatch dashboard provides infrastructure visibility.”

That architecture explanation alone gives you a strong answer if an interviewer says, **“Walk me through your solution architecture.”**
