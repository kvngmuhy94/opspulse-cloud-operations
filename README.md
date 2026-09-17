# OpsPulse — AWS Cloud Operations & DevOps Platform

![AWS](https://img.shields.io/badge/AWS-Cloud-orange)
![EC2](https://img.shields.io/badge/Amazon%20EC2-Compute-orange)
![CloudWatch](https://img.shields.io/badge/CloudWatch-Monitoring-orange)
![Terraform](https://img.shields.io/badge/Terraform-IaC-purple)
![Docker](https://img.shields.io/badge/Docker-Containers-blue)
![FastAPI](https://img.shields.io/badge/FastAPI-API-green)
![Python](https://img.shields.io/badge/Python-3.x-blue)
![GitHub Actions](https://img.shields.io/badge/GitHub%20Actions-CI%2FCD-black)
![Linux](https://img.shields.io/badge/Linux-Amazon%20Linux-yellow)
![Status](https://img.shields.io/badge/Status-Completed-brightgreen)

---

## Overview

OpsPulse is a production-style AWS cloud operations project designed to demonstrate how cloud infrastructure, containerisation, monitoring, logging, automation, and incident-response practices can support a reliable application environment.

The platform runs a containerised FastAPI service on Amazon EC2, provisions cloud infrastructure with Terraform, validates source changes through GitHub Actions, and centralises monitoring and application logs through Amazon CloudWatch.

The project demonstrates enterprise-style cloud operations covering:

- AWS cloud engineering
- Infrastructure as Code
- Docker containerisation
- Linux administration
- CI/CD validation
- IAM role-based access
- Centralised logging
- Infrastructure monitoring
- Health and readiness checks
- Incident detection
- Production troubleshooting
- Service recovery
- Operational documentation

---

## Operational Problem

Cloud-hosted applications can become unavailable for many reasons, including:

- stopped or failed containers
- incorrect port mappings
- IAM permission issues
- infrastructure configuration errors
- invalid credentials
- SSH authentication failures
- resource pressure
- deployment mistakes
- missing cloud permissions

Without centralised monitoring, logging, health checks, and documented recovery procedures, troubleshooting can become slow and inconsistent.

OpsPulse was designed to simulate how a cloud operations team can build and operate a service that is observable, recoverable, and easier to troubleshoot.

The project focuses not only on deploying an application, but also on how that application is monitored, investigated, and restored when something goes wrong.

---

## Key Features

- AWS-hosted FastAPI application
- Docker containerisation
- Terraform-managed infrastructure
- Amazon EC2 deployment
- GitHub Actions CI workflow
- CloudWatch CPU monitoring
- CloudWatch alarm configuration
- Centralised application logging
- IAM instance role integration
- Health endpoint
- Readiness endpoint
- Swagger API documentation
- SSH-based server administration
- Controlled incident simulation
- Docker troubleshooting
- Service recovery validation
- Incident-response runbook

---

# Solution Architecture

```text
                     Developer
                         |
                         v
                  GitHub Repository
                         |
                         v
                  GitHub Actions CI
                         |
                         v
                  Application Code
                         |
                         v
                    Docker Image
                         |
                         v
                Amazon EC2 Instance
                         |
          --------------------------------
          |              |               |
          v              v               v
      FastAPI         IAM Role        CloudWatch
      Service                         Monitoring
          |                              |
    ---------------              -------------------
    |      |      |               |        |        |
    v      v      v               v        v        v
 /health /ready /docs          Metrics   Alarm    Logs
                                          |
                                          v
                               opspulse-high-cpu
