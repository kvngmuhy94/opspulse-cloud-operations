# OpsPulse Incident Runbook

## Purpose

This runbook documents how to investigate and recover OpsPulse when the application health endpoint becomes unavailable.

## Environment

- Application: OpsPulse FastAPI service
- Platform: AWS EC2
- Container Runtime: Docker
- Infrastructure: Terraform
- Monitoring: Amazon CloudWatch
- Centralised Logs: `/opspulse/application`
- Production Log Stream: `opspulse-production`

## Symptoms

Typical symptoms include:

- `/health` endpoint becomes unavailable
- Public application endpoint refuses connections
- Docker container is stopped or exited
- CloudWatch stops receiving successful request logs

## Initial Health Check

```bash
curl http://localhost:8000/health

Eof
